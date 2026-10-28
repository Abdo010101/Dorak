import 'package:flutter/material.dart';

/// Dorak design-system color tokens.
///
/// Values resolved from `design/design-tokens.md` and Figma DS
/// (file `YOXpQ9ovXe8cwaVBszRmOJ`). Access via
/// `Theme.of(context).extension<AppColorsTheme>()`.
@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({
    required this.borderPrimary,
    required this.focusRing,
    required this.textPrimary,
    required this.textSecondary,
    required this.surfaceField,
    required this.fieldBorder,
    required this.borderWarning,
    required this.textWarning,
    required this.errorRing,
    required this.borderSuccess,
    required this.textSuccess,
    required this.successRing,
    required this.white,
    required this.primaryTint,
    required this.skeleton,
    required this.onPrimary,
  });

  final Color borderPrimary;
  final Color focusRing;
  final Color textPrimary;
  final Color textSecondary;
  final Color surfaceField;
  final Color fieldBorder;
  final Color borderWarning;
  final Color textWarning;
  final Color errorRing;
  final Color borderSuccess;
  final Color textSuccess;
  final Color successRing;
  final Color white;
  final Color primaryTint;
  final Color skeleton;
  final Color onPrimary;

  factory AppColorsTheme.light() => const AppColorsTheme(
        borderPrimary: Color(0xFF014AE0),
        focusRing: Color.fromRGBO(1, 74, 224, 0.08),
        textPrimary: Color(0xFF1D1D1D),
        textSecondary: Color(0xFF6D6D6D),
        surfaceField: Color(0xFFFAFAFA),
        fieldBorder: Color(0xFFE5E5E5),
        borderWarning: Color(0xFFB54708),
        textWarning: Color(0xFFB54708),
        errorRing: Color.fromRGBO(209, 82, 39, 0.08),
        borderSuccess: Color(0xFF067647),
        textSuccess: Color(0xFF067647),
        successRing: Color.fromRGBO(6, 118, 71, 0.08),
        white: Color(0xFFFFFFFF),
        primaryTint: Color(0xFFEBF1FE),
        skeleton: Color(0xFFEFEFEF),
        onPrimary: Color(0xFFFFFFFF),
      );

  static AppColorsTheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorsTheme>() ?? AppColorsTheme.light();

  @override
  AppColorsTheme copyWith({
    Color? borderPrimary,
    Color? focusRing,
    Color? textPrimary,
    Color? textSecondary,
    Color? surfaceField,
    Color? fieldBorder,
    Color? borderWarning,
    Color? textWarning,
    Color? errorRing,
    Color? borderSuccess,
    Color? textSuccess,
    Color? successRing,
    Color? white,
    Color? primaryTint,
    Color? skeleton,
    Color? onPrimary,
  }) {
    return AppColorsTheme(
      borderPrimary: borderPrimary ?? this.borderPrimary,
      focusRing: focusRing ?? this.focusRing,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      surfaceField: surfaceField ?? this.surfaceField,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      borderWarning: borderWarning ?? this.borderWarning,
      textWarning: textWarning ?? this.textWarning,
      errorRing: errorRing ?? this.errorRing,
      borderSuccess: borderSuccess ?? this.borderSuccess,
      textSuccess: textSuccess ?? this.textSuccess,
      successRing: successRing ?? this.successRing,
      white: white ?? this.white,
      primaryTint: primaryTint ?? this.primaryTint,
      skeleton: skeleton ?? this.skeleton,
      onPrimary: onPrimary ?? this.onPrimary,
    );
  }

  @override
  AppColorsTheme lerp(ThemeExtension<AppColorsTheme>? other, double t) {
    if (other is! AppColorsTheme) return this;
    return AppColorsTheme(
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      surfaceField: Color.lerp(surfaceField, other.surfaceField, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      borderWarning: Color.lerp(borderWarning, other.borderWarning, t)!,
      textWarning: Color.lerp(textWarning, other.textWarning, t)!,
      errorRing: Color.lerp(errorRing, other.errorRing, t)!,
      borderSuccess: Color.lerp(borderSuccess, other.borderSuccess, t)!,
      textSuccess: Color.lerp(textSuccess, other.textSuccess, t)!,
      successRing: Color.lerp(successRing, other.successRing, t)!,
      white: Color.lerp(white, other.white, t)!,
      primaryTint: Color.lerp(primaryTint, other.primaryTint, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
    );
  }
}
