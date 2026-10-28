import 'package:flutter/material.dart';

/// Corner radius scale. DS fixes 12 px for input/button/chip/card/thumbnail.
@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii({
    required this.small,
    required this.medium,
    required this.large,
  });

  final double small;
  final double medium;
  final double large;

  factory AppRadii.base() => const AppRadii(small: 8, medium: 12, large: 16);

  static AppRadii of(BuildContext context) =>
      Theme.of(context).extension<AppRadii>() ?? AppRadii.base();

  @override
  AppRadii copyWith({double? small, double? medium, double? large}) {
    return AppRadii(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }

  @override
  AppRadii lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(
      small: small + (other.small - small) * t,
      medium: medium + (other.medium - medium) * t,
      large: large + (other.large - large) * t,
    );
  }
}
