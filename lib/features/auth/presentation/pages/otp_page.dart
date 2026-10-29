import 'dart:async';

import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 04 / 05 OTP (Figma `201:1471` + `202:1445`).
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const _cellCount = 4;
  static const _brandGreen = Color(0xFF1F8046);
  static const _ctaDisabled = Color(0xFF4C4C4C);

  final _otpKey = GlobalKey<AppOtpFieldState>();
  String _code = '';

  int _secondsLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().resetFlags();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 0) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  bool get _complete => _code.length == _cellCount;

  String _maskedNumber(String phone) {
    if (phone.length < 4) return '+966 $phone';
    final tail = phone.substring(phone.length - 2);
    return '+966 55 ••• ••$tail';
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          listenWhen: (p, c) => p.verified != c.verified && c.verified,
          listener: (context, state) {
            if (state.needsProfile) {
              context.goNamed(RouteNames.completeInfo);
            } else {
              context.goNamed(RouteNames.signedIn);
            }
          },
          builder: (context, state) {
            final hasError =
                state.status == Status.failure && state.errorMessage != null;
            final loading = state.status == Status.loading;
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
                        'otp_title'.tr(),
                        textAlign: TextAlign.right,
                        style: type.display.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'otp_subtitle'.tr(),
                        textAlign: TextAlign.right,
                        style: type.textLgRegular
                            .copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _maskedNumber(state.phone),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.goNamed(RouteNames.login);
                              }
                            },
                            child: Text(
                              'otp_change_number'.tr(),
                              style: type.textLgSemibold
                                  .copyWith(color: _brandGreen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      AppOtpField(
                        key: _otpKey,
                        length: _cellCount,
                        hasError: hasError,
                        onChanged: (v) {
                          setState(() => _code = v);
                          context.read<AuthCubit>().setOtp(v);
                        },
                        onCompleted: (_) =>
                            context.read<AuthCubit>().verifyOtp(),
                      ),
                      const SizedBox(height: 24),
                      if (hasError) ...[
                        _ErrorRow(
                          message: state.errorMessage!,
                          colors: colors,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _otpKey.currentState?.clear();
                              setState(() => _code = '');
                              context.read<AuthCubit>().setOtp('');
                              context.read<AuthCubit>().sendOtp();
                              _startTimer();
                            },
                            child: Text(
                              'otp_resend_cta'.tr(),
                              style: type.textLgSemibold
                                  .copyWith(color: _brandGreen),
                            ),
                          ),
                        ),
                      ] else
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '00:${_secondsLeft.toString().padLeft(2, '0')}',
                                style: type.textLgSemibold
                                    .copyWith(color: _brandGreen),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'otp_resend'.tr(),
                                style: type.textLgRegular
                                    .copyWith(color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                _CtaBar(
                  enabled: _complete && !loading,
                  loading: loading,
                  onPressed: _complete
                      ? () => context.read<AuthCubit>().verifyOtp()
                      : null,
                  disabledColor: _ctaDisabled,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
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
          AppBackButton(onPressed: onBack),
          const Spacer(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            message.tr(),
            textAlign: TextAlign.center,
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
    required this.enabled,
    required this.loading,
    required this.onPressed,
    required this.disabledColor,
  });
  final bool enabled;
  final bool loading;
  final VoidCallback? onPressed;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 14),
        child: AppPrimaryButton(
          label: 'otp_cta'.tr(),
          isLoading: loading,
          isDisabled: !enabled,
          onPressed: enabled ? onPressed : null,
        ),
      ),
    );
  }
}
