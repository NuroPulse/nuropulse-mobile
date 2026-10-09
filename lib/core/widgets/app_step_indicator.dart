import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

enum _SegmentState { done, current, upcoming }

/// "Langkah N dari total" always shown as text; the segment bar is a
/// supplement, never the only indicator (per the design system's README).
class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    super.key,
    required this.current,
    required this.total,
    required this.labels,
  }) : assert(total > 0, 'total must be positive'),
       assert(
         current >= 1 && current <= total,
         'current must be between 1 and total',
       ),
       assert(
         labels.length == total,
         "number of labels must be equal to total",
       );

  final int current;
  final int total;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Langkah $current dari $total',
          style: TextStyle(
            fontFamily: FontTheme.fontFamily,
            fontSize: 15,
            height: 22 / 15,
            fontWeight: FontWeight.w700,
            color: BaseColors.primary,
          ),
        ),
        const SizedBox(height: 8), // space-2
        Row(
          spacing: 4, // space-1
          children: List.generate(total, (index) {
            final step = index + 1;
            final state = step < current
                ? _SegmentState.done
                : (step == current
                      ? _SegmentState.current
                      : _SegmentState.upcoming);
            return Expanded(child: _Segment(state: state));
          }),
        ),
        const SizedBox(height: 4), // space-1
        Text(
          labels[current - 1],
          style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.state});

  final _SegmentState state;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color border, double width) = switch (state) {
      _SegmentState.done => (BaseColors.primary, BaseColors.primary, 1.0),
      _SegmentState.current => (
        BaseColors.primarySoft,
        BaseColors.primary,
        2.0,
      ),
      _SegmentState.upcoming => (
        BaseColors.surfaceSunken,
        BaseColors.lineStrong,
        1.0,
      ),
    };

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border, width: width),
        borderRadius: BorderRadius.circular(999), // radius-full
      ),
    );
  }
}
