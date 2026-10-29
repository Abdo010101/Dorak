import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_radii.dart';
import 'package:dorakpattient/core/theme/app_spacing.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/feedback/app_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SpecialtyOption {
  const SpecialtyOption({
    required this.key,
    required this.icon,
    required this.labelKey,
  });
  final String key;
  final IconData icon;
  final String labelKey;
}

const List<SpecialtyOption> kAllSpecialties = [
  SpecialtyOption(
    key: 'dental',
    icon: Icons.medical_services_outlined,
    labelKey: 'specialty_dental',
  ),
  SpecialtyOption(
    key: 'kids',
    icon: Icons.child_care_outlined,
    labelKey: 'specialty_kids',
  ),
  SpecialtyOption(
    key: 'dermatology',
    icon: Icons.spa_outlined,
    labelKey: 'specialty_dermatology',
  ),
  SpecialtyOption(
    key: 'cardio',
    icon: Icons.favorite_border,
    labelKey: 'specialty_cardio',
  ),
  SpecialtyOption(
    key: 'ortho',
    icon: Icons.accessibility_new_outlined,
    labelKey: 'specialty_ortho',
  ),
  SpecialtyOption(
    key: 'eye',
    icon: Icons.remove_red_eye_outlined,
    labelKey: 'specialty_eye',
  ),
  SpecialtyOption(
    key: 'ent',
    icon: Icons.hearing_outlined,
    labelKey: 'specialty_ent',
  ),
  SpecialtyOption(
    key: 'internal',
    icon: Icons.local_hospital_outlined,
    labelKey: 'specialty_internal',
  ),
  SpecialtyOption(
    key: 'obgyn',
    icon: Icons.pregnant_woman_outlined,
    labelKey: 'specialty_obgyn',
  ),
  SpecialtyOption(
    key: 'neuro',
    icon: Icons.psychology_outlined,
    labelKey: 'specialty_neuro',
  ),
  SpecialtyOption(
    key: 'psych',
    icon: Icons.self_improvement_outlined,
    labelKey: 'specialty_psych',
  ),
  SpecialtyOption(
    key: 'general',
    icon: Icons.health_and_safety_outlined,
    labelKey: 'specialty_general',
  ),
];

class AllSpecialtiesSheet extends StatelessWidget {
  const AllSpecialtiesSheet({super.key, this.selectedKey, this.onSelected});

  final String? selectedKey;
  final ValueChanged<SpecialtyOption>? onSelected;

  static Future<SpecialtyOption?> show(
    BuildContext context, {
    String? selectedKey,
  }) {
    return AppBottomSheet.show<SpecialtyOption>(
      context,
      isScrollControlled: true,
      title: 'explore_specialty_sheet_title'.tr(),
      child: AllSpecialtiesSheet(
        selectedKey: selectedKey,
        onSelected: (opt) => Navigator.of(context).pop(opt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    final typo = AppTypography.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: spacing.md),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: spacing.md,
          crossAxisSpacing: spacing.md,
          childAspectRatio: 0.95,
        ),
        itemCount: kAllSpecialties.length,
        itemBuilder: (_, i) {
          final opt = kAllSpecialties[i];
          final selected = selectedKey == opt.key;
          return InkWell(
            borderRadius: BorderRadius.circular(radii.medium),
            onTap: () => onSelected?.call(opt),
            child: Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: selected ? colors.primaryTint : colors.white,
                borderRadius: BorderRadius.circular(radii.medium),
                border: Border.all(
                  color: selected ? colors.borderPrimary : colors.fieldBorder,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    opt.icon,
                    size: 28,
                    color: selected
                        ? colors.borderPrimary
                        : colors.textPrimary,
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    opt.labelKey.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: typo.textMdRegular.copyWith(
                      color: selected
                          ? colors.borderPrimary
                          : colors.textPrimary,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
