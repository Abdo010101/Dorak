import 'dart:async';

import 'package:dorakpattient/core/router/route_names.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 04 OTP (Figma `201:1471`).
class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.maskedNumber = '+966 55 ••• ••67'});
  final String maskedNumber;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const _cellCount = 4;
  static const _accent = Color(0xFF1F8046);
  static const _accentFocusRing = Color(0x14014AE0);
  static const _accentCaret = Color(0xFF19A055);
  static const _controlFocused = Color(0xFF014AE0);
  static const _bgField = Color(0xFFFAFAFA);
  static const _borderTertiary = Color(0xFFE5E5E5);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _textDisplay = Color(0xFF0C0C0C);
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
  }

  void _startTimer() {
    _timer?.cancel();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => context.canPop() ? context.pop() : null),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  const Text(
                    'otp_title',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ).tr(),
                  const SizedBox(height: 8),
                  const Text(
                    'otp_subtitle',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14, color: _textSecondary),
                  ).tr(),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            context.canPop() ? context.pop() : null,
                        child: const Text(
                          'otp_change_number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _accent,
                          ),
                        ).tr(),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.maskedNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _OtpRow(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    onChanged: () => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '00:${_secondsLeft.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _accent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'otp_resend',
                          style: TextStyle(
                            fontSize: 14,
                            color: _textSecondary,
                          ),
                        ).tr(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _CtaBar(
              enabled: _complete,
              onPressed: _complete
                  ? () => context.goNamed(RouteNames.home)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 24,
              color: _OtpPageState._textPrimary,
            ),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

class _OtpRow extends StatelessWidget {
  const _OtpRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  return Container(
                    decoration: BoxDecoration(
                      color: _OtpPageState._bgField,
                      border: Border.all(
                        color: focused
                            ? _OtpPageState._controlFocused
                            : _OtpPageState._borderTertiary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: focused
                          ? const [
                              BoxShadow(
                                color: _OtpPageState._accentFocusRing,
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _OtpPageState._textDisplay,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        cursorColor: _OtpPageState._accentCaret,
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

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.enabled, required this.onPressed});
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: enabled
                  ? const Color(0xFF1F8046)
                  : _OtpPageState._ctaDisabled,
              foregroundColor: enabled ? Colors.white : const Color(0xFFD2D2D2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onPressed,
            child: const Text(
              'otp_cta',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ).tr(),
          ),
        ),
      ),
    );
  }
}
