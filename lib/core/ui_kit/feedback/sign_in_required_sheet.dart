import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Guard a gated action: returns `true` if the user is signed in, otherwise
/// opens [SignInRequiredSheet] and returns `false`. Callers should early-return
/// on `false`.
Future<bool> ensureSignedIn(BuildContext context) async {
  final auth = context.read<AuthCubit>().state;
  if (auth.isAuthenticated) return true;
  await SignInRequiredSheet.show(context);
  return false;
}

/// Pop the current route back to the nearest ancestor when the user is a
/// guest. Use from `initState` (via `addPostFrameCallback`) on gated pages
/// reached by deep link so the user does not land on an auth-only screen.
void popIfGuest(BuildContext context) {
  final auth = context.read<AuthCubit>().state;
  if (auth.isAuthenticated) return;
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final confirmed = await SignInRequiredSheet.show(context);
    if (!confirmed && context.mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  });
}


/// Guest-gate bottom sheet (Figma `jA3JQXye9DbBrxzNkEj9nf` node `350:3072`).
///
/// Call `SignInRequiredSheet.show(context)` whenever an action is restricted
/// to signed-in users. Returns `true` if the user tapped any sign-in CTA
/// (phone / Apple / Google) — a hint that the caller should abort the gated
/// action and let the auth flow take over. Returns `false` on dismiss / "Not
/// now" / scrim tap.
class SignInRequiredSheet extends StatelessWidget {
  const SignInRequiredSheet._();

  static const _accent = Color(0xFF1F8046);
  static const _accentGlow = Color(0xFF98F3B2);
  static const _accentBg50 = Color(0xFFDBFEE3);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _borderNeutralSecondary = Color(0xFFD2D2D2);
  static const _black = Color(0xFF010101);
  static const _scrim = Color(0x4D161616);

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: _scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const SignInRequiredSheet._(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: _borderNeutralSecondary,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _accentBg50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 28,
                color: _accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'signin_sheet_title'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'signin_sheet_body'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: _textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            _PrimaryCta(
              onTap: () {
                Navigator.of(context).pop(true);
                context.pushNamed(RouteNames.login);
              },
            ),
            const SizedBox(height: 10),
            _SocialButton(
              label: 'signin_sheet_cta_apple'.tr(),
              asset: 'assets/images/intro/apple_logo.svg',
              background: _black,
              foreground: Colors.white,
              onTap: () {
                Navigator.of(context).pop(true);
                context.pushNamed(RouteNames.welcome);
              },
            ),
            const SizedBox(height: 10),
            _SocialButton(
              label: 'signin_sheet_cta_google'.tr(),
              asset: 'assets/images/intro/google_logo.svg',
              background: Colors.white,
              foreground: _textPrimary,
              borderColor: _borderNeutralSecondary,
              onTap: () {
                Navigator.of(context).pop(true);
                context.pushNamed(RouteNames.welcome);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: _textSecondary,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text('signin_sheet_dismiss'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: SignInRequiredSheet._accentGlow,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: SignInRequiredSheet._accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_outlined, size: 20),
              const SizedBox(width: 10),
              Text(
                'signin_sheet_cta_phone'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.asset,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final String asset;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: borderColor == null
                  ? null
                  : Border.all(color: borderColor!),
            ),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                SvgPicture.asset(asset, width: 20, height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
