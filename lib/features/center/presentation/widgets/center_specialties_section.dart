import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../data/mock/center_mock.dart';
import '../../domain/entities/center_entity.dart';

class CenterSpecialtiesSection extends StatelessWidget {
  const CenterSpecialtiesSection({super.key, required this.specialties});

  final List<SpecialtyEntity> specialties;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            'center_specialties_title'
                .tr(args: [specialties.length.toString()]),
            style: typo.titleSm.copyWith(color: colors.textPrimary),
          ),
        ),
        SizedBox(height: spacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (int i = 0; i < specialties.length; i++) ...[
              if (i > 0) SizedBox(width: spacing.lg),
              AppSpecialtyTile(
                icon: Icon(CenterMock.iconFor(specialties[i].key),
                    size: 28, color: colors.borderPrimary),
                label: specialties[i].label,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
