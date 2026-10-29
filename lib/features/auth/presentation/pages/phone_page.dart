import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 03 / 03b Phone number (Figma `201:1422` + `352:3204`).
class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  static const _brandGreen = Color(0xFF1F8046);
  static const _brandGreenGlow = Color(0xFF98F3B2);
  static const _accentFocusRing = Color(0xFFDBFEE3);
  static const _borderPrimary = Color(0xFF19A055);

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<AuthCubit>().setPhone(_controller.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().resetFlags();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final type = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.otpSent != c.otpSent && c.otpSent,
          listener: (context, state) => context.goNamed(RouteNames.otp),
          builder: (context, state) {
            final hasError = state.status == Status.failure &&
                state.errorMessage != null;
            return Column(
              children: [
                _TopBar(
                  color: colors.textPrimary,
                  onBack: () => context.canPop() ? context.pop() : null,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    children: [
                      Text(
                        'phone_title'.tr(),
                        textAlign: TextAlign.right,
                        style: type.display.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'phone_subtitle'.tr(),
                        textAlign: TextAlign.right,
                        style: type.textLgRegular
                            .copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'phone_label'.tr(),
                          style: type.textMdSemibold
                              .copyWith(color: colors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _PhoneField(
                        controller: _controller,
                        colors: colors,
                        hasError: hasError,
                      ),
                      const SizedBox(height: 6),
                      if (hasError)
                        _ErrorRow(
                          message: state.errorMessage!,
                          colors: colors,
                        )
                      else
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'phone_helper'.tr(),
                            style: type.textMdRegular
                                .copyWith(color: colors.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
                _CtaBar(
                  loading: state.status == Status.loading,
                  onPressed: () => context.read<AuthCubit>().sendOtp(),
                  brand: _brandGreen,
                  glow: _brandGreenGlow,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Color get borderPrimary => _borderPrimary;
  static Color get focusRing => _accentFocusRing;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.color});
  final VoidCallback? onBack;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_right
                  : Icons.chevron_left,
              size: 24,
              color: color,
            ),
            onPressed: onBack,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.colors,
    required this.hasError,
  });
  final TextEditingController controller;
  final AppColorsTheme colors;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        hasError ? colors.borderWarning : _PhonePageState.borderPrimary;
    final ringColor =
        hasError ? colors.errorRing : _PhonePageState.focusRing;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.surfaceField,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: ringColor, spreadRadius: 3),
        ],
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  hintText: '55 123 4567',
                  hintStyle: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
              ),
            ),
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceField,
              border: Border(
                right: BorderSide(color: colors.fieldBorder),
              ),
            ),
            child: Text(
              '+966',
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({required this.message, required this.colors});
  final String message;
  final AppColorsTheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            message.tr(),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12, color: colors.textWarning),
          ),
        ),
        const SizedBox(width: 6),
        Icon(Icons.error_outline, size: 16, color: colors.textWarning),
      ],
    );
  }
}

class _CtaBar extends StatelessWidget {
  const _CtaBar({
    required this.loading,
    required this.onPressed,
    required this.brand,
    required this.glow,
  });
  final bool loading;
  final VoidCallback onPressed;
  final Color brand;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: glow, blurRadius: 5, offset: const Offset(0, 1)),
              ],
            ),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: brand,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: loading ? null : onPressed,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'phone_cta'.tr(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
