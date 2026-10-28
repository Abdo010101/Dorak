import 'dart:async';

import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
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
/// Centered Dorak vertical mark + loader. Boot order:
/// 1. `AuthCubit.loadCurrentUser()` (hydrates persisted session from prefs)
/// 2. prime Dio `Content-language` header
/// 3. kick off `GeneralCubit.getGeneralData()` (not awaited)
/// 4. route to Home / Welcome / Intro based on `isAuthenticated` + first-time
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _sharedPref = locator<SharedPref>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthCubit>();
    await auth.loadCurrentUser();
    if (!mounted) return;

    InjectionClass.dio.options.headers['Content-language'] =
        context.locale.languageCode;
    unawaited(context.read<GeneralCubit>().getGeneralData());

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    await _route();
  }

  Future<void> _route() async {
    final state = context.read<AuthCubit>().state;
    if (state.isAuthenticated) {
      final phone = state.user?.patient?.phone;
      if (phone == null || phone.isEmpty) {
        context.goNamed(RouteNames.welcome);
      } else {
        context.goNamed(RouteNames.home);
      }
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
    return Scaffold(
      backgroundColor: colors.white,
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/images/intro/dorak_vertical.svg',
              width: 151,
              height: 114,
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
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
        ],
      ),
    );
  }
}
