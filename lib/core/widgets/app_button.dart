import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger }

enum AppButtonIconPosition { leading, trailing }

/// Reusable button matching the NuroPulse design system.
///
/// Disabled look is not a [AppButtonVariant]: pass `onPressed: null` (or set
/// [isLoading] to true) and every variant resolves to the same muted state.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.iconPosition = AppButtonIconPosition.leading,
    this.isLoading = false,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;
  final bool isLoading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    // A loading button stays visually enabled (so it keeps its variant
    // color instead of looking disabled) but swallows taps. An explicitly
    // disabled button (onPressed == null) stays disabled either way.
    final effectiveOnPressed = onPressed == null
        ? null
        : (isLoading ? () {} : onPressed);
    final style = _styleFor(variant);
    final content = isLoading
        ? _LoadingIndicator(color: _foregroundFor(variant))
        : _ButtonContent(label: label, icon: icon, iconPosition: iconPosition);

    final button = switch (variant) {
      AppButtonVariant.outline => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
      AppButtonVariant.primary ||
      AppButtonVariant.secondary ||
      AppButtonVariant.danger => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: content,
      ),
    };

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  static Color _foregroundFor(AppButtonVariant variant) {
    return switch (variant) {
      AppButtonVariant.primary => BaseColors.onPrimary,
      AppButtonVariant.secondary => BaseColors.onSecondary,
      AppButtonVariant.danger => BaseColors.onDanger,
      AppButtonVariant.outline || AppButtonVariant.text => BaseColors.primary,
    };
  }

  static ButtonStyle _styleFor(AppButtonVariant variant) {
    const minimumSize = Size.fromHeight(56); // touch-min
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // radius-md
    );
    final base = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(minimumSize),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24),
      ),
      shape: WidgetStatePropertyAll(shape),
      textStyle: const WidgetStatePropertyAll(FontTheme.label),
      elevation: const WidgetStatePropertyAll(0),
    );

    return switch (variant) {
      AppButtonVariant.primary => base.copyWith(
        backgroundColor: _colorByState(
          BaseColors.primary,
          BaseColors.surfaceSunken,
        ),
        foregroundColor: _colorByState(
          BaseColors.onPrimary,
          BaseColors.inkMuted,
        ),
        overlayColor: _overlayByState(BaseColors.onPrimary),
      ),
      AppButtonVariant.secondary => base.copyWith(
        backgroundColor: _colorByState(
          BaseColors.secondary,
          BaseColors.surfaceSunken,
        ),
        foregroundColor: _colorByState(
          BaseColors.onSecondary,
          BaseColors.inkMuted,
        ),
        overlayColor: _overlayByState(BaseColors.onSecondary),
      ),
      AppButtonVariant.danger => base.copyWith(
        backgroundColor: _colorByState(
          BaseColors.danger,
          BaseColors.surfaceSunken,
        ),
        foregroundColor: _colorByState(
          BaseColors.onDanger,
          BaseColors.inkMuted,
        ),
        overlayColor: _overlayByState(BaseColors.onDanger),
      ),
      AppButtonVariant.outline => base.copyWith(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: _colorByState(BaseColors.primary, BaseColors.inkMuted),
        side: _sideByState(BaseColors.lineStrong, BaseColors.line),
        overlayColor: _overlayByState(BaseColors.primary),
      ),
      AppButtonVariant.text => base.copyWith(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: _colorByState(BaseColors.primary, BaseColors.inkMuted),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        overlayColor: _overlayByState(BaseColors.primary),
      ),
    };
  }

  static WidgetStateProperty<Color?> _colorByState(
    Color enabled,
    Color disabled,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.disabled) ? disabled : enabled;
    });
  }

  static WidgetStateProperty<BorderSide?> _sideByState(
    Color enabled,
    Color disabled,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      final color = states.contains(WidgetState.disabled) ? disabled : enabled;
      return BorderSide(color: color);
    });
  }

  static WidgetStateProperty<Color?> _overlayByState(Color base) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return base.withValues(alpha: 0.16);
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return base.withValues(alpha: 0.08);
      }
      return null;
    });
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.iconPosition,
  });

  final String label;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(label, overflow: TextOverflow.ellipsis);
    }

    final iconWidget = Icon(icon, size: 20);
    final text = Flexible(child: Text(label, overflow: TextOverflow.ellipsis));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconPosition == AppButtonIconPosition.leading
          ? [iconWidget, const SizedBox(width: 8), text]
          : [text, const SizedBox(width: 8), iconWidget],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
