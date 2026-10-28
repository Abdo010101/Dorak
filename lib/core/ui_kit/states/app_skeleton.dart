import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';

/// Simple rectangular skeleton placeholder. Opt-in shimmer later.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.radius,
  });

  final double height;
  final double width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final radii = AppRadii.of(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: colors.skeleton,
        borderRadius: BorderRadius.circular(radius ?? radii.small),
      ),
    );
  }
}
