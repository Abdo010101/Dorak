import 'package:flutter/material.dart';

import 'app_colors_theme.dart';
import 'app_radii.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'text_direction_x.dart';

/// Dorak app theme. Resolve tokens via `Theme.of(context).extension<T>()`.
class AppTheme {
  const AppTheme._();

  static ThemeData light({Locale? locale}) {
    final colors = AppColorsTheme.light();
    final typo = AppTypography.forLocale(locale);
    final spacing = AppSpacing.base();
    final radii = AppRadii.base();
    final shadows = AppShadows.base();
    final family = AppFontFamilies.resolveLocale(locale);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: family,
      scaffoldBackgroundColor: colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.borderPrimary,
        primary: colors.borderPrimary,
        onPrimary: colors.onPrimary,
        surface: colors.white,
        onSurface: colors.textPrimary,
        error: colors.borderWarning,
        onError: colors.white,
      ),
      textTheme: TextTheme(
        bodySmall: typo.textMdRegular,
        bodyMedium: typo.textLgRegular,
        bodyLarge: typo.textLgSemibold,
        labelLarge: typo.textLgSemibold,
        titleSmall: typo.titleSm,
        titleMedium: typo.titleSm,
        titleLarge: typo.titleMd,
        headlineSmall: typo.titleMd,
        headlineMedium: typo.display,
        headlineLarge: typo.display,
      ).apply(bodyColor: colors.textPrimary, displayColor: colors.textPrimary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceField,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: typo.textLgRegular.copyWith(color: colors.textSecondary),
        labelStyle: typo.textMdSemibold.copyWith(color: colors.textPrimary),
        border: _fieldBorder(colors.fieldBorder, radii.medium),
        enabledBorder: _fieldBorder(colors.fieldBorder, radii.medium),
        focusedBorder: _fieldBorder(colors.borderPrimary, radii.medium, 1.5),
        errorBorder: _fieldBorder(colors.borderWarning, radii.medium),
        focusedErrorBorder: _fieldBorder(colors.borderWarning, radii.medium, 1.5),
        errorStyle: typo.textMdRegular.copyWith(color: colors.textWarning),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.borderPrimary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radii.medium),
          ),
          textStyle: typo.textLgSemibold,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.borderPrimary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radii.medium),
          ),
          textStyle: typo.textLgSemibold,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.fieldBorder),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radii.medium),
          ),
          textStyle: typo.textLgSemibold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.borderPrimary,
          textStyle: typo.textLgSemibold,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceField,
        selectedColor: colors.primaryTint,
        labelStyle: typo.textLgSemibold.copyWith(color: colors.textPrimary),
        secondaryLabelStyle: typo.textLgSemibold.copyWith(
          color: colors.borderPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.medium),
          side: BorderSide(color: colors.fieldBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      cardTheme: CardThemeData(
        color: colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.medium),
          side: BorderSide(color: colors.fieldBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.white,
        surfaceTintColor: colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radii.large),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.white,
        surfaceTintColor: colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.large),
        ),
        titleTextStyle: typo.titleSm.copyWith(color: colors.textPrimary),
        contentTextStyle: typo.textLgRegular.copyWith(
          color: colors.textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.white,
        surfaceTintColor: colors.white,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: typo.titleSm.copyWith(color: colors.textPrimary),
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      dividerTheme: DividerThemeData(color: colors.fieldBorder, thickness: 1),
      extensions: <ThemeExtension<dynamic>>[
        colors,
        typo,
        spacing,
        radii,
        shadows,
      ],
    );
  }

  static OutlineInputBorder _fieldBorder(
    Color color,
    double radius, [
    double width = 1.0,
  ]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
