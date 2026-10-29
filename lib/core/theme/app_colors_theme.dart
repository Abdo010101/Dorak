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
    required this.primary200,
    required this.secondaryTint,
    required this.textInfo,
    required this.neutral25,
    required this.neutral50,
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
  final Color primary200;
  final Color secondaryTint;
  final Color textInfo;
  final Color neutral25;
  final Color neutral50;
  final Color skeleton;
  final Color onPrimary;

  factory AppColorsTheme.light() => const AppColorsTheme(
        borderPrimary: Color(0xFF1F8046),
        focusRing: Color.fromRGBO(31, 128, 70, 0.08),
        textPrimary: Color(0xFF1D1D1D),
        textSecondary: Color(0xFF4C4C4C),
        surfaceField: Color(0xFFFAFAFA),
        fieldBorder: Color(0xFFE5E5E5),
        borderWarning: Color(0xFFB54708),
        textWarning: Color(0xFFB54708),
        errorRing: Color.fromRGBO(209, 82, 39, 0.08),
        borderSuccess: Color(0xFF067647),
        textSuccess: Color(0xFF067647),
        successRing: Color.fromRGBO(6, 118, 71, 0.08),
        white: Color(0xFFFFFFFF),
        primaryTint: Color(0xFFDBFEE3),
        primary200: Color(0xFF98F3B2),
        secondaryTint: Color(0xFFE5EFFF),
        textInfo: Color(0xFF175CD3),
        neutral25: Color(0xFFFAFAFA),
        neutral50: Color(0xFFF4F4F4),
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
    Color? primary200,
    Color? secondaryTint,
    Color? textInfo,
    Color? neutral25,
    Color? neutral50,
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
      primary200: primary200 ?? this.primary200,
      secondaryTint: secondaryTint ?? this.secondaryTint,
      textInfo: textInfo ?? this.textInfo,
      neutral25: neutral25 ?? this.neutral25,
      neutral50: neutral50 ?? this.neutral50,
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
      primary200: Color.lerp(primary200, other.primary200, t)!,
      secondaryTint: Color.lerp(secondaryTint, other.secondaryTint, t)!,
      textInfo: Color.lerp(textInfo, other.textInfo, t)!,
      neutral25: Color.lerp(neutral25, other.neutral25, t)!,
      neutral50: Color.lerp(neutral50, other.neutral50, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
    );
  }
}
