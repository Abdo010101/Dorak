import 'package:flutter/material.dart';

/// 4-step spacing scale from `design/design-tokens.md`.
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.xs,
    required this.xs2,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xs;
  final double xs2;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  factory AppSpacing.base() => const AppSpacing(
        xs: 4,
        xs2: 6,
        sm: 8,
        md: 12,
        lg: 16,
        xl: 24,
        xxl: 32,
      );

  static AppSpacing of(BuildContext context) =>
      Theme.of(context).extension<AppSpacing>() ?? AppSpacing.base();

  @override
  AppSpacing copyWith({
    double? xs,
    double? xs2,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      xs2: xs2 ?? this.xs2,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t),
      xs2: lerpDouble(xs2, other.xs2, t),
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
      xxl: lerpDouble(xxl, other.xxl, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
