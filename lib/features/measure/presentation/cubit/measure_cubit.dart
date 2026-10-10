import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/dsp/models/tremor_result.dart';
import 'package:nuropulse/dsp/models/tremor_status.dart';
import 'package:nuropulse/features/measure/domain/entity/invalid_reason.dart';
import 'package:nuropulse/features/measure/domain/repositories/measurement_repository.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_state.dart';
import 'package:nuropulse/features/measure/presentation/cubit/measure_timing.dart';

/// Drives one recording from countdown to decision. Samples never go into
/// state.
class MeasureCubit extends Cubit<MeasureState> {
  MeasureCubit(this._repository, [this._timing = const MeasureTiming()])
    : super(const MeasureState.idle());

  /// 3 s of user acceleration at 100 Hz.
  static const liveSamples = 300;

  final MeasurementRepository _repository;
  final MeasureTiming _timing;
  final Stopwatch _stopwatch = Stopwatch();

  Timer? _timer;
  Duration? _recordingDuration;
  bool _recording = false;

  Future<void> start({required Duration recordingDuration}) async {
    if (state is! MeasureIdle) return;

    _recordingDuration = recordingDuration;
    var left = _timing.countdownSeconds;
    emit(MeasureState.countdown(left));
    _timer = Timer.periodic(_timing.countdownTick, (timer) {
      left--;
      if (left > 0) {
        emit(MeasureState.countdown(left));
        return;
      }
      timer.cancel();
      unawaited(_beginRecording());
    });
  }

  Future<void> _beginRecording() async {
    try {
      await _repository.startRecording(_recordingDuration!);
    } on Failure catch (failure) {
      emit(MeasureState.failure(failure));
      return;
    }

    _recording = true;
    _stopwatch
      ..reset()
      ..start();
    emit(
      MeasureState.recording(
        elapsed: Duration.zero,
        totalDuration: _recordingDuration!,
        window: _repository.liveWindow(liveSamples),
      ),
    );
    _timer = Timer.periodic(_timing.liveTick, (_) => _onLiveTick());
  }

  void _onLiveTick() {
    final elapsed = _stopwatch.elapsed;
    if (elapsed >= _recordingDuration!) {
      unawaited(_finish());
      return;
    }
    emit(
      MeasureState.recording(
        elapsed: elapsed,
        totalDuration: _recordingDuration!,
        window: _repository.liveWindow(liveSamples),
      ),
    );
  }

  Future<void> _finish() async {
    _timer?.cancel();
    _stopwatch.stop();
    _recording = false;
    emit(const MeasureState.processing());

    try {
      final outcome = await _repository.finishRecording();
      final result = outcome.result;
      if (result.status == TremorStatus.invalid) {
        emit(MeasureState.invalid(_reasonsFrom(result)));
      } else {
        emit(
          MeasureState.success(
            result: result,
            measurementId: outcome.measurementId,
          ),
        );
      }
    } on Failure catch (failure) {
      emit(MeasureState.failure(failure));
    }
  }

  /// Called when the app leaves the foreground. Stops the recording and
  /// marks it invalid, because a phone that moves or is handled corrupts
  /// the signal. The page wires this to `AppLifecycleState.paused`.
  void interrupt() {
    if (!_recording) return;
    _timer?.cancel();
    _stopwatch.stop();
    _recording = false;
    unawaited(_repository.cancelRecording());
    emit(const MeasureState.invalid([InvalidReason.interrupted]));
  }

  /// Cancels the countdown or the recording without analyzing it.
  Future<void> cancel() async {
    _timer?.cancel();
    _stopwatch.stop();
    if (_recording) {
      _recording = false;
      await _repository.cancelRecording();
    }
    emit(const MeasureState.idle());
  }

  /// Returns to idle so the user can measure again ("Ulangi").
  void retry() {
    if (state is MeasureIdle || state is MeasureCountdown) return;
    if (state is MeasureRecording || state is MeasureProcessing) return;
    emit(const MeasureState.idle());
  }

  List<InvalidReason> _reasonsFrom(TremorResult result) {
    return [
      for (final gate in result.gates)
        if (!gate.passed) invalidReasonFor(gate.check),
    ];
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    if (_recording) {
      unawaited(_repository.cancelRecording());
    }
    return super.close();
  }
}
