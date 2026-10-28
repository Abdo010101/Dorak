import 'dart:async';

import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Phase 8 — Auth 01 Splash (Figma node `201:1334`).
///
/// Centered Dorak vertical mark + loader. Preserves legacy bootstrap:
/// check auth, prime Dio header, prefetch general data, then route to
/// Home / Welcome / Intro based on auth + first-time-flag.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _sharedPref = locator<SharedPref>();
  AuthController? _authController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    _authController = Provider.of<AuthController>(context, listen: false);
    await _authController!.checkUserLoggedIn();
    if (!mounted) return;

    InjectionClass.dio.options.headers['Content-language'] =
        context.locale.languageCode;
    unawaited(
      Provider.of<GeneralController>(context, listen: false).getData(),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    await _route();
  }

  Future<void> _route() async {
    final auth = _authController!;
    if (auth.isLoggedIn) {
      final phone = auth.currentUser?.patient?.phone;
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

