import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/strings.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../logic/language_cubit.dart';
import '../../logic/language_state.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return BlocListener<LanguageCubit, LanguageState>(
      listenWhen: (p, c) => p.locale != c.locale,
      listener: (ctx, state) async {
        await ctx.setLocale(state.locale);
        if (ctx.mounted) ctx.goNamed(RouteNames.splash);
      },
      child: Scaffold(
        backgroundColor: colors.surfaceField,
        appBar: AppTopBar(title: AppStrings.kLanguage.tr()),
        body: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (ctx, state) {
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              children: [
                AppCard(
                  onTap: () =>
                      ctx.read<LanguageCubit>().setLocale(const Locale('ar')),
                  child: _LanguageRow(
                    label: 'العربية',
                    selected: state.locale.languageCode == 'ar',
                  ),
                ),
                SizedBox(height: spacing.md),
                AppCard(
                  onTap: () =>
                      ctx.read<LanguageCubit>().setLocale(const Locale('en')),
                  child: _LanguageRow(
                    label: 'English',
                    selected: state.locale.languageCode == 'en',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.md,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? colors.borderPrimary : colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
