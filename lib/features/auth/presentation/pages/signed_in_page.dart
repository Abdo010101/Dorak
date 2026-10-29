import 'dart:async';

import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 08 Signed in (Figma `352:3321`).
class SignedInPage extends StatefulWidget {
  const SignedInPage({super.key});

  @override
  State<SignedInPage> createState() => _SignedInPageState();
}

class _SignedInPageState extends State<SignedInPage> {
  static const _brandGreen = Color(0xFF1F8046);
  static const _brandGreenRing = Color(0x1F1F8046);

  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _redirectTimer = Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      context.goNamed(RouteNames.home);
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final type = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 112,
                height: 112,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _brandGreenRing,
                ),
                child: Container(
                  width: 76,
                  height: 76,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _brandGreen,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 36),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'signed_in_title'.tr(),
                textAlign: TextAlign.center,
                style: type.display.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'signed_in_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: type.textLgRegular
                      .copyWith(color: colors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
