import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Phase 11 — Account 07 Guest card (Figma `209:2862`). Shown on the
/// profile page when the user is not authenticated.
class GuestCard extends StatelessWidget {
  const GuestCard({super.key, required this.onSignIn});
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: colors.neutral25,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 28,
              color: colors.borderPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'profile_guest_title'.tr(),
            textAlign: TextAlign.center,
            style: typo.titleSm.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'profile_guest_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: typo.textLgRegular.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 14),
          AppPrimaryButton(
            label: 'profile_guest_cta'.tr(),
            onPressed: onSignIn,
          ),
        ],
      ),
    );
  }
}
