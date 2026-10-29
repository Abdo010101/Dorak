import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_radii.dart';
import 'package:dorakpattient/core/theme/app_shadows.dart';
import 'package:dorakpattient/core/theme/app_spacing.dart';
import 'package:dorakpattient/core/theme/app_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme.light', () {
    final theme = AppTheme.light();

    test('registers all 5 ThemeExtensions', () {
      expect(theme.extension<AppColorsTheme>(), isNotNull);
      expect(theme.extension<AppTypography>(), isNotNull);
      expect(theme.extension<AppSpacing>(), isNotNull);
      expect(theme.extension<AppRadii>(), isNotNull);
      expect(theme.extension<AppShadows>(), isNotNull);
    });

    test('color tokens match DS values', () {
      final c = theme.extension<AppColorsTheme>()!;
      expect(c.borderPrimary, const Color(0xFF1F8046));
      expect(c.textPrimary, const Color(0xFF1D1D1D));
      expect(c.textSecondary, const Color(0xFF4C4C4C));
      expect(c.surfaceField, const Color(0xFFFAFAFA));
      expect(c.fieldBorder, const Color(0xFFE5E5E5));
      expect(c.borderWarning, const Color(0xFFB54708));
      expect(c.borderSuccess, const Color(0xFF067647));
      expect(c.primaryTint, const Color(0xFFDBFEE3));
    });

    test('spacing scale', () {
      final s = theme.extension<AppSpacing>()!;
      expect(s.xs, 4);
      expect(s.xs2, 6);
      expect(s.sm, 8);
      expect(s.md, 12);
      expect(s.lg, 16);
      expect(s.xl, 24);
      expect(s.xxl, 32);
    });

    test('radii scale', () {
      final r = theme.extension<AppRadii>()!;
      expect(r.small, 8);
      expect(r.medium, 12);
      expect(r.large, 16);
    });

    test('Arabic locale selects Tajawal font', () {
      final arTheme = AppTheme.light(locale: const Locale('ar'));
      expect(arTheme.textTheme.bodyLarge?.fontFamily, 'Tajawal');
    });

    test('Non-Arabic locale selects Plus Jakarta Sans', () {
      final enTheme = AppTheme.light(locale: const Locale('en'));
      expect(enTheme.textTheme.bodyLarge?.fontFamily, 'Plus Jakarta Sans');
    });
  });
}
