import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nuropulse/core/errors/failure.dart';
import 'package:nuropulse/features/connection/domain/entity/connected_doctor.dart';

part 'connection_state.freezed.dart';

/// idle | connecting | connected | failure. "connected" covers both just
/// having entered a code and viewing an existing connection. Named
/// [DoctorConnectionState], not `ConnectionState`, since that name already
/// belongs to Flutter's own `StreamBuilder`/`FutureBuilder` enum.
@freezed
sealed class DoctorConnectionState with _$DoctorConnectionState {
  const factory DoctorConnectionState.idle() = DoctorConnectionIdle;

  const factory DoctorConnectionState.connecting() = DoctorConnectionConnecting;

  const factory DoctorConnectionState.connected(ConnectedDoctor doctor) =
      DoctorConnectionConnected;

  const factory DoctorConnectionState.failure(Failure failure) =
      DoctorConnectionFailure;
}
