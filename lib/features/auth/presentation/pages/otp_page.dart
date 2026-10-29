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
import 'package:flutter/services.dart';
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
  static const _accentCaret = Color(0xFF19A055);
  static const _controlFocused = Color(0xFF014AE0);
  static const _accentFocusRing = Color(0x14014AE0);
  static const _ctaDisabled = Color(0xFF4C4C4C);

  final _controllers = List<TextEditingController>.generate(
    _cellCount,
    (_) => TextEditingController(),
  );
  final _focusNodes = List<FocusNode>.generate(_cellCount, (_) => FocusNode());

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

  bool get _complete => _controllers.every((c) => c.text.isNotEmpty);

  String get _joined => _controllers.map((c) => c.text).join();

  String _maskedNumber(String phone) {
    if (phone.length < 4) return '+966 $phone';
    final tail = phone.substring(phone.length - 2);
    return '+966 55 ••• ••$tail';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
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
            final hasError = state.status == Status.failure &&
                state.errorMessage != null;
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                context.canPop() ? context.pop() : null,
                            child: Text(
                              'otp_change_number'.tr(),
                              style: type.textLgSemibold
                                  .copyWith(color: _brandGreen),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _maskedNumber(state.phone),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _OtpRow(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                        hasError: hasError,
                        colors: colors,
                        onChanged: () {
                          context.read<AuthCubit>().setOtp(_joined);
                          setState(() {});
                        },
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
                              for (final c in _controllers) {
                                c.clear();
                              }
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

  static Color get controlFocused => _controlFocused;
  static Color get focusRing => _accentFocusRing;
  static Color get caret => _accentCaret;
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

class _OtpRow extends StatelessWidget {
  const _OtpRow({
    required this.controllers,
    required this.focusNodes,
    required this.hasError,
    required this.colors,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool hasError;
  final AppColorsTheme colors;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controllers.length, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i == controllers.length - 1 ? 0 : 14),
          child: SizedBox(
            width: 62,
            height: 64,
            child: Focus(
              onFocusChange: (_) => onChanged(),
              child: Builder(
                builder: (ctx) {
                  final focused = focusNodes[i].hasFocus;
                  final borderColor = hasError
                      ? colors.borderWarning
                      : focused
                          ? _OtpPageState.controlFocused
                          : colors.fieldBorder;
                  return Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceField,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: focused
                          ? [
                              BoxShadow(
                                color: hasError
                                    ? colors.errorRing
                                    : _OtpPageState.focusRing,
                                blurRadius: 0,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: TextField(
                        controller: controllers[i],
                        focusNode: focusNodes[i],
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        cursorColor: _OtpPageState.caret,
                        onChanged: (v) {
                          if (v.isNotEmpty && i < controllers.length - 1) {
                            focusNodes[i + 1].requestFocus();
                          } else if (v.isEmpty && i > 0) {
                            focusNodes[i - 1].requestFocus();
                          }
                          onChanged();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
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
