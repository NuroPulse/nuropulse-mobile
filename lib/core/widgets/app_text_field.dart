import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

/// [error] (a caller-known message) always wins over [validator] and shows
/// immediately, without waiting for user interaction or [Form.validate].
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.hint,
    this.error,
    this.unit,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.focusNode,
    this.validator,
    this.autovalidateMode,
  }) : assert(
         controller == null || initialValue == null,
         'Isi salah satu saja: controller atau initialValue.',
       );

  /// Always visible above the field. Never substitute [placeholder] for this.
  final String label;

  /// Ghost text shown inside the field while it is empty.
  final String? placeholder;

  /// Helper text shown below the field. Hidden whenever [error] is set.
  final String? hint;

  /// Replaces [hint] below the field and switches the border to danger.
  final String? error;

  /// Unit suffix inside the field, e.g. "tahun".
  final String? unit;

  final TextEditingController? controller;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // radius-md
      borderSide: const BorderSide(color: BaseColors.lineStrong, width: 2),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: FontTheme.label.copyWith(color: BaseColors.ink),
        ),
        const SizedBox(height: 8), // space-2
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          obscureText: widget.obscureText && _obscured,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          style: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
          cursorColor: BaseColors.primary,
          autovalidateMode: widget.error != null
              ? AutovalidateMode.always
              : (widget.autovalidateMode ?? AutovalidateMode.disabled),
          validator: (value) => widget.error ?? widget.validator?.call(value),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, // space-4
              vertical: 14,
            ),
            filled: true,
            fillColor: widget.enabled
                ? BaseColors.surfaceRaised
                : BaseColors.surfaceSunken,
            hintText: widget.placeholder,
            hintStyle: FontTheme.bodyLg.copyWith(color: BaseColors.inkMuted),
            helperText: widget.hint,
            helperStyle: FontTheme.caption.copyWith(color: BaseColors.inkMuted),
            helperMaxLines: 3,
            errorMaxLines: 3,
            errorStyle: FontTheme.caption.copyWith(
              color: BaseColors.danger,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon ?? _obscureToggle(),
            suffix: widget.unit == null
                ? null
                : Text(
                    widget.unit!,
                    style: FontTheme.bodyLg.copyWith(
                      color: BaseColors.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            border: border,
            enabledBorder: border,
            disabledBorder: border.copyWith(
              borderSide: const BorderSide(color: BaseColors.line, width: 2),
            ),
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: BaseColors.ink, width: 2),
            ),
            errorBorder: border.copyWith(
              borderSide: const BorderSide(color: BaseColors.danger, width: 2),
            ),
            focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: BaseColors.danger, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _obscureToggle() {
    if (!widget.obscureText) return null;
    return IconButton(
      icon: Icon(
        _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: BaseColors.inkMuted,
      ),
      onPressed: () => setState(() => _obscured = !_obscured),
    );
  }
}
