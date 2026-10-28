import 'package:flutter/material.dart';

/// PROPOSED shadows. Replace with values from Figma DS once published.
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({required this.card, required this.sheet});

  final List<BoxShadow> card;
  final List<BoxShadow> sheet;

  factory AppShadows.base() => const AppShadows(
        card: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(16, 24, 40, 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        sheet: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(16, 24, 40, 0.08),
            offset: Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      );

  static AppShadows of(BuildContext context) =>
      Theme.of(context).extension<AppShadows>() ?? AppShadows.base();

  @override
  AppShadows copyWith({List<BoxShadow>? card, List<BoxShadow>? sheet}) {
    return AppShadows(card: card ?? this.card, sheet: sheet ?? this.sheet);
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return t < 0.5 ? this : other;
  }
}
