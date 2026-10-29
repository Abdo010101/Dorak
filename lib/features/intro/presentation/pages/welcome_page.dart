import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_spacing.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/features/settings/logic/language_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 02 Welcome (Figma node `201:1345`).
///
/// Phone-first auth entry with Apple/Google providers and guest link.
/// Brand green `#1F8046` is the Figma CTA color; DS token refresh will fold
/// it into `AppColorsTheme` after the BRD lands.
const _brandGreen = Color(0xFF1F8046);
const _socialBlack = Color(0xFF010101);
const _borderSecondary = Color(0xFFD2D2D2);
const _borderTertiary = Color(0xFFE5E5E5);
const _textDisplay = Color(0xFF0C0C0C);
const _textSecondary = Color(0xFF4C4C4C);

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(child: Center(child: _Content())),
            const _GuestLink(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LanguagePill(),
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              color: _textDisplay,
            ),
            onPressed: () =>
                context.canPop() ? context.pop() : null,
          ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final isAr = context.locale.languageCode == 'ar';
        final next = isAr ? const Locale('en') : const Locale('ar');
        context.read<LanguageCubit>().setLocale(next);
        await context.setLocale(next);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _borderTertiary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          context.locale.languageCode == 'ar' ? 'English' : 'العربية',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _textDisplay,
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/intro/dorak_mark.svg',
            width: 68,
            height: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'welcome_title'.tr(),
            textAlign: TextAlign.center,
            style: type.display.copyWith(color: const Color(0xFF1D1D1D)),
          ),
          const SizedBox(height: 10),
          Text(
            'welcome_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: type.textLgRegular.copyWith(color: _textSecondary),
          ),
          const SizedBox(height: 40),
          _PrimaryCTA(
            label: 'welcome_cta_phone'.tr(),
            onPressed: () => context.goNamed(RouteNames.register),
          ),
          const SizedBox(height: 20),
          const _OrDivider(),
          const SizedBox(height: 20),
          _SocialButton(
            label: 'welcome_cta_apple'.tr(),
            assetPath: 'assets/images/intro/apple_logo.svg',
            backgroundColor: _socialBlack,
            foregroundColor: Colors.white,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          _SocialButton(
            label: 'welcome_cta_google'.tr(),
            assetPath: 'assets/images/intro/google_logo.svg',
            backgroundColor: Colors.white,
            foregroundColor: _textDisplay,
            bordered: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _PrimaryCTA extends StatelessWidget {
  const _PrimaryCTA({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      onPressed: onPressed,
      leadingIcon: SvgPicture.asset(
        'assets/images/intro/call_icon.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: _borderTertiary, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or'.tr(),
            style: const TextStyle(fontSize: 14, color: _textSecondary),
          ),
        ),
        const Expanded(child: Divider(color: _borderTertiary, height: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.assetPath,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.bordered = false,
  });

  final String label;
  final String assetPath;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: bordered ? const BorderSide(color: _borderSecondary) : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: foregroundColor,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(assetPath, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}

class _GuestLink extends StatelessWidget {
  const _GuestLink();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        InjectionClass.dio.options.headers['Content-language'] =
            context.locale.languageCode;
        context.goNamed(RouteNames.home);
      },
      child: Text(
        'welcome_guest'.tr(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: _brandGreen,
        ),
      ),
    );
  }
}

