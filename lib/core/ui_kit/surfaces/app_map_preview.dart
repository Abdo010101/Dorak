import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Decorative static map preview + pin + "Open map" link.
/// Figma `175:968`.
class AppMapPreview extends StatelessWidget {
  const AppMapPreview({
    super.key,
    required this.pinLabel,
    required this.openMapLabel,
    this.onOpenMap,
  });

  final String pinLabel;
  final String openMapLabel;
  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final radii = AppRadii.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radii.medium),
      child: Container(
        height: 104,
        color: colors.neutral50,
        child: Stack(
          children: [
            // decorative roads
            Positioned(left: 60, top: 0, bottom: 0, child: _road(colors, 6)),
            Positioned(left: 150, top: 0, bottom: 0, child: _road(colors, 5)),
            Positioned(left: 248, top: 0, bottom: 0, child: _road(colors, 6)),
            Positioned(left: 322, top: 0, bottom: 0, child: _road(colors, 5)),
            Positioned(left: 0, right: 0, top: 18, child: _roadH(colors, 5)),
            Positioned(left: 0, right: 0, top: 46, child: _roadH(colors, 6)),
            // parks
            Positioned(
              left: 4, top: 0, width: 48, height: 16,
              child: _park(colors),
            ),
            Positioned(
              left: 258, top: 0, width: 58, height: 16,
              child: _park(colors),
            ),
            Positioned(
              left: 332, top: 26, width: 40, height: 18,
              child: _park(colors),
            ),
            // map pin + label
            PositionedDirectional(
              top: 16,
              start: 40,
              child: _PinCluster(label: pinLabel),
            ),
            // open-map button
            PositionedDirectional(
              top: 67,
              end: 16,
              child: Material(
                color: colors.white,
                borderRadius: BorderRadius.circular(radii.medium),
                child: InkWell(
                  onTap: onOpenMap,
                  borderRadius: BorderRadius.circular(radii.medium),
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: spacing.md - 2,
                      vertical: spacing.xs2 - 1,
                    ),
                    decoration: BoxDecoration(
                      color: colors.white,
                      borderRadius: BorderRadius.circular(radii.medium),
                      border: Border.all(color: colors.fieldBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          openMapLabel,
                          style: typo.textMdSemibold
                              .copyWith(color: colors.textInfo),
                        ),
                        SizedBox(width: spacing.xs2),
                        Icon(Icons.map_outlined, size: 20, color: colors.textInfo),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _road(AppColorsTheme colors, double w) =>
      Container(width: w, color: colors.white);

  Widget _roadH(AppColorsTheme colors, double h) =>
      Container(height: h, color: colors.white);

  Widget _park(AppColorsTheme colors) => Container(
        decoration: BoxDecoration(
          color: colors.primaryTint,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}

class _PinCluster extends StatelessWidget {
  const _PinCluster({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return SizedBox(
      width: 127,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(7),
            decoration: BoxDecoration(
              color: colors.primaryTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(Icons.location_on, size: 18, color: colors.borderPrimary),
          ),
          Transform.translate(
            offset: const Offset(0, -6),
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: spacing.md - 2,
                vertical: spacing.xs - 1,
              ),
              decoration: BoxDecoration(
                color: colors.primaryTint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: typo.textMdRegular.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
