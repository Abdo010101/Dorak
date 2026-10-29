import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';

/// Rounded avatar — image or placeholder. Default radius matches DS medium (12 px).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageAsset,
    this.imageUrl,
    this.size = 64,
    this.radius,
    this.placeholderColor,
  });

  final String? imageAsset;
  final String? imageUrl;
  final double size;
  final double? radius;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final r = radius ?? AppRadii.of(context).medium;
    final decoration = BoxDecoration(
      color: placeholderColor ?? colors.secondaryTint,
      borderRadius: BorderRadius.circular(r),
    );

    Widget? child;
    if (imageAsset != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Image.asset(imageAsset!, fit: BoxFit.cover, width: size, height: size),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Image.network(imageUrl!, fit: BoxFit.cover, width: size, height: size,
            errorBuilder: (_, __, ___) => const SizedBox()),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: decoration,
      child: child,
    );
  }
}
