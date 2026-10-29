import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_typography.dart';
import 'app_primary_button.dart' show AppButtonSize;

/// Dorak Secondary (outline) button. Figma DS `4034:200`.
///
/// Spec: 46 px Medium (default), 36 px Small. Radius 12. Padding 20 h / 12 v.
/// White bg, 0.5 px `fieldBorder` outline, shadow `0 0 0 1 #e5e5e5`.
/// Text 14 semibold, color `textPrimary`.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.expand = true,
    this.size = AppButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool isDisabled;
  final bool expand;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final disabled = isDisabled || isLoading;
    final enabled = !disabled;

    final height = switch (size) {
      AppButtonSize.medium => 46.0,
      AppButtonSize.small => 36.0,
      AppButtonSize.xsmall => 32.0,
    };
    final hPad = switch (size) {
      AppButtonSize.medium => 20.0,
      AppButtonSize.small => 16.0,
      AppButtonSize.xsmall => 12.0,
    };

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return colors.neutral50;
        if (states.contains(WidgetState.pressed)) return colors.primaryTint;
        return colors.white;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textSecondary;
        }
        return colors.textPrimary;
      }),
      side: WidgetStateProperty.resolveWith<BorderSide>((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered)) {
          return BorderSide(color: colors.borderPrimary, width: 1);
        }
        return BorderSide(color: colors.fieldBorder, width: 1);
      }),
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: hPad),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.medium),
        ),
      ),
      textStyle: WidgetStatePropertyAll(typo.textLgSemibold),
      animationDuration: const Duration(milliseconds: 520),
    );

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.borderPrimary),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 8),
              ],
              Text(label, style: typo.textLgSemibold),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                trailingIcon!,
              ],
            ],
          );

    final btn = OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: child,
    );
    final sized = SizedBox(height: height, child: btn);
    return expand ? SizedBox(width: double.infinity, child: sized) : sized;
  }
}
