import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../widgets/settings_tile.dart';

/// Pilot page — settings list. Pure `ui_kit`. No `AppColors.*`, no raw `TextStyle`.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return Scaffold(
      backgroundColor: colors.surfaceField,
      appBar: AppTopBar(title: AppStrings.kSettings.tr()),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        children: [
          AppCard(
            child: Column(
              children: [
                SettingsTile(
                  label: AppStrings.kLanguage.tr(),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed(RouteNames.language),
                ),
                const AppDivider(),
                SettingsTile(
                  label: AppStrings.kNotifications.tr(),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.md),
          AppCard(
            child: SettingsTile(
              label: AppStrings.kAppReview.tr(),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.goNamed(RouteNames.appReview),
            ),
          ),
        ],
      ),
    );
  }
}
