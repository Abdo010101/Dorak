import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_shadows.dart';

/// Generic surface card. 12 px radius per DS.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final radii = AppRadii.of(context);
    final shadows = AppShadows.of(context);
    return Material(
      color: colors.white,
      borderRadius: BorderRadius.circular(radii.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radii.medium),
        child: Container(
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(radii.medium),
            border: Border.all(color: colors.fieldBorder),
            boxShadow: elevated ? shadows.card : null,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
