import 'dart:async';

import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 01 Splash (Figma node `201:1334`).
///
/// Centered Dorak mark that spins one slow clock-turn, then brand text
/// fades in below. Boot order:
/// 1. `AuthCubit.loadCurrentUser()` (hydrates persisted session from prefs)
/// 2. prime Dio `Content-Language` header
/// 3. kick off `GeneralCubit.getGeneralData()` (not awaited)
/// 4. route to Home / Welcome / Intro based on `isAuthenticated` + first-time
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  final _sharedPref = locator<SharedPref>();

  late final AnimationController _spin;
  late final AnimationController _text;
  late final Animation<double> _rotation;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _text = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotation = CurvedAnimation(parent: _spin, curve: Curves.linear);
    _textFade = CurvedAnimation(parent: _text, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _text, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _spin.repeat();
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _text.forward();
      });
      _bootstrap();
    });
  }

  @override
  void dispose() {
    _spin.dispose();
    _text.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthCubit>();
    await auth.loadCurrentUser();
    if (!mounted) return;

    InjectionClass.dio.options.headers['Content-Language'] =
        context.locale.languageCode;
    unawaited(context.read<GeneralCubit>().getGeneralData());

    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    await _route();
  }

  Future<void> _route() async {
    final state = context.read<AuthCubit>().state;
    // Having a Bearer token is enough to land on home; the profile-complete
    // step was already gated during OTP sign-in via `needsProfile`. The old
    // `patient.phone.isNotEmpty` guard was kicking signed-in users back to
    // welcome on cold start / hot restart whenever the stored patient object
    // was missing `phone` (backend may send only `full_phone`).
    if (state.isAuthenticated) {
      context.goNamed(RouteNames.home);
      return;
    }
    final firstTime = await _sharedPref.getFirstTime() ?? false;
    await _sharedPref.storeFirstTime();
    if (!mounted) return;
    context.goNamed(firstTime ? RouteNames.welcome : RouteNames.intro);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final type = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 108,
                    height: 126,
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/images/intro/dorak_mark_body.svg',
                          width: 108,
                          height: 126,
                        ),
                        SvgPicture.asset(
                          'assets/images/intro/dorak_mark_hour.svg',
                          width: 108,
                          height: 126,
                        ),
                        AnimatedBuilder(
                          animation: _rotation,
                          builder: (_, child) => Transform.rotate(
                            angle: _rotation.value * 2 * 3.1415926535,
                            alignment: const Alignment(-0.1098, 0.2497),
                            child: child,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/intro/dorak_mark_hands.svg',
                            width: 108,
                            height: 126,
                          ),
                        ),
                        Positioned(
                          left: 44.13,
                          top: 75.22,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF032F7A),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'app_name'.tr(),
                            textAlign: TextAlign.center,
                            style: type.display
                                .copyWith(color: const Color(0xFF1D1D1D)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'splash_tagline'.tr(),
                            textAlign: TextAlign.center,
                            style: type.textLgRegular
                                .copyWith(color: const Color(0xFF4C4C4C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: FadeTransition(
                  opacity: _textFade,
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: SvgPicture.asset(
                      'assets/images/intro/loader.svg',
                      width: 32,
                      height: 32,
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
}
