import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_typography.dart';

/// Dorak Primary button. Figma DS `4034:148` (filled green).
///
/// Spec: 44 px Medium (default), 36 px Small, 32 px XSmall.
/// Radius 12. Padding 20 h / 12 v. Text 14 semibold on-color white.
/// Hover `#1C5E35`, Pressed `#103D20`, Disabled `#D2D2D2` bg + `#4C4C4C` text.
/// Default drop-shadow 0 1 5 glow `primary200 (#98F3B2)`.
enum AppButtonSize { small, medium, xsmall }

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
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

  static const _hovered = Color(0xFF1C5E35);
  static const _pressed = Color(0xFF103D20);
  static const _disabledBg = Color(0xFFD2D2D2);
  static const _disabledFg = Color(0xFF4C4C4C);

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);

    final height = switch (size) {
      AppButtonSize.medium => 44.0,
      AppButtonSize.small => 36.0,
      AppButtonSize.xsmall => 32.0,
    };
    final hPad = switch (size) {
      AppButtonSize.medium => 20.0,
      AppButtonSize.small => 16.0,
      AppButtonSize.xsmall => 12.0,
    };

    final disabled = isDisabled || isLoading;
    final enabled = !disabled;

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return _disabledBg;
        if (states.contains(WidgetState.pressed)) return _pressed;
        if (states.contains(WidgetState.hovered)) return _hovered;
        return colors.borderPrimary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return _disabledFg;
        return colors.onPrimary;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return _pressed.withValues(alpha: .2);
        }
        return null;
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
      elevation: const WidgetStatePropertyAll(0),
    );

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
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

    final btn = FilledButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: child,
    );

    // Glow shadow only on enabled default state (hover/press lose the glow in
    // Figma). Flutter can't easily toggle the parent shadow by state, so apply
    // it when the control is logically enabled.
    final wrapped = enabled
        ? DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radii.medium),
              boxShadow: [
                BoxShadow(
                  color: colors.primary200,
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: btn,
          )
        : btn;

    final sized = SizedBox(height: height, child: wrapped);
    return expand ? SizedBox(width: double.infinity, child: sized) : sized;
  }
}
