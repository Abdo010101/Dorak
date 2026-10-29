import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 07 Sign-in required sheet (Figma `202:1598` / `202:1676`).
///
/// Call `SignInSheet.show(context)` from any guarded flow (e.g., booking a
/// visit). Figma overlays this sheet on top of a scrim; `showModalBottomSheet`
/// handles that natively.
class SignInSheet extends StatelessWidget {
  const SignInSheet({super.key});

  static const _socialBlack = Color(0xFF010101);
  static const _borderSecondary = Color(0xFFD2D2D2);
  static const _primaryTint = Color(0xFFEBF1FE);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SignInSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final type = AppTypography.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.fieldBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryTint,
                ),
                child: const Icon(Icons.lock_outline,
                    size: 28, color: Color(0xFF014AE0)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'signin_sheet_title'.tr(),
              textAlign: TextAlign.center,
              style: type.titleMd.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'signin_sheet_subtitle'.tr(),
              textAlign: TextAlign.center,
              style:
                  type.textLgRegular.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'signin_sheet_cta'.tr(),
              onPressed: () {
                Navigator.of(context).pop();
                context.goNamed(RouteNames.login);
              },
            ),
            const SizedBox(height: 10),
            _SocialButton(
              label: 'welcome_cta_apple'.tr(),
              assetPath: 'assets/images/intro/apple_logo.svg',
              background: _socialBlack,
              foreground: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 10),
            _SocialButton(
              label: 'welcome_cta_google'.tr(),
              assetPath: 'assets/images/intro/google_logo.svg',
              background: Colors.white,
              foreground: colors.textPrimary,
              bordered: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'signin_sheet_dismiss'.tr(),
                  style: type.textLgSemibold
                      .copyWith(color: colors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.assetPath,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.bordered = false,
  });

  final String label;
  final String assetPath;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: bordered
              ? const BorderSide(color: SignInSheet._borderSecondary)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: foreground,
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
