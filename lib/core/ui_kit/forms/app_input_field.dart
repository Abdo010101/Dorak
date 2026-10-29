import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';

/// Dorak input field. 44 px high, 12 px radius, filled with `surfaceField`,
/// 1 px `fieldBorder`. Optional [label] above and [helperText] below.
/// Figma: Account 09 personal-info inputs (`209:3095 / 209:3101 / 209:3111`).
///
/// Layout is directional. In RTL (default locale AR) [leading] renders on the
/// right and [trailing] on the left; Flutter mirrors via `Directionality`.
class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    this.controller,
    this.label,
    this.helperText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
  });

  final TextEditingController? controller;
  final String? label;
  final String? helperText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final disabled = !enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              label!,
              style: typo.textMdSemibold.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: disabled ? colors.neutral50 : colors.surfaceField,
            border: Border.all(color: colors.fieldBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  enabled: enabled,
                  readOnly: readOnly,
                  maxLength: maxLength,
                  onChanged: onChanged,
                  onTap: onTap,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: hintText,
                    hintStyle: typo.textLgRegular.copyWith(
                      color: colors.textSecondary.withValues(alpha: .6),
                    ),
                  ),
                  style: typo.textLgRegular.copyWith(
                    color: disabled ? colors.textSecondary : colors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              helperText!,
              style: typo.textMdRegular.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }
}
