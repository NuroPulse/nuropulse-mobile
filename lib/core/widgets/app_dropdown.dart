import 'package:flutter/material.dart';
import 'package:nuropulse/core/themes/base_colors.dart';
import 'package:nuropulse/core/themes/font_theme.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// Labelled dropdown matching [AppTextField]'s visual language (not part of
/// the design system itself — there is no Dropdown component there).
///
/// [error] (a caller-known message) always wins over [validator] and shows
/// immediately, without waiting for user interaction or [Form.validate].
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.hint,
    this.error,
    this.enabled = true,
    this.validator,
    this.autovalidateMode,
  });

  final String label;
  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? placeholder;
  final String? hint;
  final String? error;
  final bool enabled;
  final FormFieldValidator<T?>? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), // radius-md
      borderSide: const BorderSide(color: BaseColors.lineStrong, width: 2),
    );
    final isEnabled = enabled && onChanged != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FontTheme.label.copyWith(color: BaseColors.ink)),
        const SizedBox(height: 8), // space-2
        FormField<T>(
          initialValue: value,
          autovalidateMode: error != null
              ? AutovalidateMode.always
              : (autovalidateMode ?? AutovalidateMode.disabled),
          validator: (val) => error ?? validator?.call(val),
          builder: (field) {
            return DropdownMenu<T>(
              // DropdownMenu only reads initialSelection on first build, so
              // force a remount when the value changes from outside (e.g. a
              // Cubit resetting the form) rather than via onSelected below.
              key: ValueKey(value),
              initialSelection: value,
              enabled: isEnabled,
              expandedInsets: EdgeInsets.zero,
              enableSearch: false,
              textStyle: FontTheme.bodyLg.copyWith(color: BaseColors.ink),
              hintText: placeholder,
              helperText: hint,
              errorText: field.errorText,
              onSelected: (val) {
                field.didChange(val);
                onChanged?.call(val);
              },
              dropdownMenuEntries: [
                for (final item in items)
                  DropdownMenuEntry<T>(
                    value: item.value,
                    label: item.label,
                    enabled: item.enabled,
                    style: MenuItemButton.styleFrom(
                      foregroundColor: item.enabled
                          ? BaseColors.ink
                          : BaseColors.inkMuted,
                      textStyle: FontTheme.bodyLg,
                    ),
                  ),
              ],
              inputDecorationTheme: InputDecorationTheme(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, // space-4
                  vertical: 14,
                ),
                filled: true,
                fillColor: isEnabled
                    ? BaseColors.surfaceRaised
                    : BaseColors.surfaceSunken,
                hintStyle: FontTheme.bodyLg.copyWith(
                  color: BaseColors.inkMuted,
                ),
                helperStyle: FontTheme.caption.copyWith(
                  color: BaseColors.inkMuted,
                ),
                helperMaxLines: 3,
                errorMaxLines: 3,
                errorStyle: FontTheme.caption.copyWith(
                  color: BaseColors.danger,
                  fontWeight: FontWeight.w600,
                ),
                border: border,
                enabledBorder: border,
                disabledBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: BaseColors.line,
                    width: 2,
                  ),
                ),
                focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: BaseColors.ink, width: 2),
                ),
                errorBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: BaseColors.danger,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: border.copyWith(
                  borderSide: const BorderSide(
                    color: BaseColors.danger,
                    width: 2,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
