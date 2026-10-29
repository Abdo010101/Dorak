import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';
import 'app_input_field.dart';

/// Password input — DS `4025:7382` Type=Password.
/// Obscures value by default and renders a trailing eye toggle.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.successText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? successText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return AppInputField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      label: widget.label,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      successText: widget.successText,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      obscureText: _obscured,
      keyboardType: TextInputType.visiblePassword,
      trailing: InkWell(
        onTap: () => setState(() => _obscured = !_obscured),
        borderRadius: BorderRadius.circular(999),
        child: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

/// Select / dropdown input — DS `4025:7382` Type=Select.
/// Read-only field with a trailing chevron that opens a bottom-sheet picker.
class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.optionLabel,
  });

  final String? label;
  final T? value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final String Function(T)? optionLabel;

  String _label(T v) => optionLabel?.call(v) ?? v.toString();

  Future<void> _open(BuildContext context) async {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final selected = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: BoxDecoration(
                  color: colors.fieldBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (label != null)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      label!,
                      style: typo.titleSm.copyWith(color: colors.textPrimary),
                    ),
                  ),
                ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: options.length,
                  separatorBuilder: (_, __) =>
                      Divider(
                    height: 1,
                    color: colors.fieldBorder,
                  ),
                  itemBuilder: (_, i) {
                    final opt = options[i];
                    final sel = opt == value;
                    return ListTile(
                      title: Text(
                        _label(opt),
                        style: typo.textLgRegular
                            .copyWith(color: colors.textPrimary),
                      ),
                      trailing: sel
                          ? Icon(
                              Icons.check,
                              size: 20,
                              color: colors.borderPrimary,
                            )
                          : null,
                      onTap: () => Navigator.of(ctx).pop(opt),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final controller = TextEditingController(
      text: value == null ? '' : _label(value as T),
    );
    return AppInputField(
      controller: controller,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      readOnly: true,
      onTap: enabled ? () => _open(context) : null,
      trailing: Icon(
        Icons.keyboard_arrow_down,
        size: 20,
        color: colors.textSecondary,
      ),
    );
  }
}

/// Mobile-number input — DS `4025:7382` Type=Mobile Number.
/// `+966` leading chip, LTR-forced, digit-only, 10 max.
class AppMobileField extends StatelessWidget {
  const AppMobileField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.successText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.dialCode = '+966',
    this.maxLength = 10,
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? successText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String dialCode;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return AppInputField(
      controller: controller,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      successText: successText,
      enabled: enabled,
      forceLtr: true,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      leading: Container(
        height: 32,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.white,
          border: Border.all(color: colors.fieldBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          dialCode,
          style: typo.textLgRegular.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}

/// Email input — DS `4025:7382` Type=Email. Convenience over [AppInputField].
class AppEmailField extends StatelessWidget {
  const AppEmailField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.successText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? successText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      successText: successText,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}
