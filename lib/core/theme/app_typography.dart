import 'package:flutter/material.dart';

import 'text_direction_x.dart';

/// Typography scale from `design/design-tokens.md`.
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.textMdRegular,
    required this.textMdSemibold,
    required this.textLgRegular,
    required this.textLgSemibold,
    required this.titleSm,
    required this.titleMd,
    required this.display,
  });

  final TextStyle textMdRegular;
  final TextStyle textMdSemibold;
  final TextStyle textLgRegular;
  final TextStyle textLgSemibold;
  final TextStyle titleSm;
  final TextStyle titleMd;
  final TextStyle display;

  factory AppTypography.forLocale(Locale? locale) {
    final family = AppFontFamilies.resolveLocale(locale);
    TextStyle s(double size, FontWeight weight, double height) => TextStyle(
          fontFamily: family,
          fontSize: size,
          fontWeight: weight,
          height: height / size,
        );
    return AppTypography(
      textMdRegular: s(12, FontWeight.w400, 18),
      textMdSemibold: s(12, FontWeight.w600, 18),
      textLgRegular: s(14, FontWeight.w400, 20),
      textLgSemibold: s(14, FontWeight.w600, 20),
      titleSm: s(16, FontWeight.w600, 24),
      titleMd: s(20, FontWeight.w700, 28),
      display: s(24, FontWeight.w700, 32),
    );
  }

  static AppTypography of(BuildContext context) =>
      Theme.of(context).extension<AppTypography>() ??
      AppTypography.forLocale(Localizations.maybeLocaleOf(context));

  @override
  AppTypography copyWith({
    TextStyle? textMdRegular,
    TextStyle? textMdSemibold,
    TextStyle? textLgRegular,
    TextStyle? textLgSemibold,
    TextStyle? titleSm,
    TextStyle? titleMd,
    TextStyle? display,
  }) {
    return AppTypography(
      textMdRegular: textMdRegular ?? this.textMdRegular,
      textMdSemibold: textMdSemibold ?? this.textMdSemibold,
      textLgRegular: textLgRegular ?? this.textLgRegular,
      textLgSemibold: textLgSemibold ?? this.textLgSemibold,
      titleSm: titleSm ?? this.titleSm,
      titleMd: titleMd ?? this.titleMd,
      display: display ?? this.display,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      textMdRegular: TextStyle.lerp(textMdRegular, other.textMdRegular, t)!,
      textMdSemibold: TextStyle.lerp(textMdSemibold, other.textMdSemibold, t)!,
      textLgRegular: TextStyle.lerp(textLgRegular, other.textLgRegular, t)!,
      textLgSemibold: TextStyle.lerp(textLgSemibold, other.textLgSemibold, t)!,
      titleSm: TextStyle.lerp(titleSm, other.titleSm, t)!,
      titleMd: TextStyle.lerp(titleMd, other.titleMd, t)!,
      display: TextStyle.lerp(display, other.display, t)!,
    );
  }
}
