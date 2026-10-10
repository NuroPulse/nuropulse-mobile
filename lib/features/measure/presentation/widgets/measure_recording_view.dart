import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';
import 'package:nuropulse/core/utils/number_format.dart';
import 'package:nuropulse/features/measure/domain/entity/live_window.dart';

class MeasureRecordingView extends StatelessWidget {
  const MeasureRecordingView({
    super.key,
    required this.elapsed,
    required this.totalDuration,
    required this.window,
  });

  final Duration elapsed;
  final Duration totalDuration;
  final LiveWindow window;

  @override
  Widget build(BuildContext context) {
    final seconds = elapsed.inMilliseconds / 1000;
    final fraction = totalDuration.inMilliseconds == 0
        ? 0.0
        : (elapsed.inMilliseconds / totalDuration.inMilliseconds).clamp(
            0.0,
            1.0,
          );
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Merekam… tahan tangan tetap rileks',
            style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: formatNumber(seconds, 0),
              style: FontTheme.data.copyWith(color: BaseColors.ink),
              children: [
                TextSpan(
                  text: ' / ${totalDuration.inSeconds}s',
                  style: FontTheme.body.copyWith(color: BaseColors.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999), // radius-full
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 10,
                backgroundColor: BaseColors.line,
                color: BaseColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: BaseColors.surfaceRaised,
                border: Border.all(color: BaseColors.line),
                borderRadius: BorderRadius.circular(20), // radius-lg
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _LiveWaveformPainter(window: window),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple live trace of the X axis. Display only — never used for analysis
/// (CLAUDE.md section 11).
class _LiveWaveformPainter extends CustomPainter {
  const _LiveWaveformPainter({required this.window});

  final LiveWindow window;

  @override
  void paint(Canvas canvas, Size size) {
    final samples = window.x;
    if (samples.length < 2) return;

    var maxAbs = 0.0;
    for (final value in samples) {
      final abs = value.abs();
      if (abs > maxAbs) maxAbs = abs;
    }
    if (maxAbs == 0) maxAbs = 1;

    final midY = size.height / 2;
    final scaleY = (size.height / 2) / maxAbs * 0.9;
    final stepX = size.width / (samples.length - 1);

    final path = Path()..moveTo(0, midY - samples[0] * scaleY);
    for (var i = 1; i < samples.length; i++) {
      path.lineTo(i * stepX, midY - samples[i] * scaleY);
    }

    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      Paint()
        ..color = BaseColors.line
        ..strokeWidth = 1,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = BaseColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_LiveWaveformPainter oldDelegate) {
    return !identical(oldDelegate.window, window);
  }
}
