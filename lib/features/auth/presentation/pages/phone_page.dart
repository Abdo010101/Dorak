import 'package:dorakpattient/core/router/route_names.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 03 Phone number (Figma `201:1422`).
class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _controller = TextEditingController();

  static const _accent = Color(0xFF1F8046);
  static const _accentFocusRing = Color(0xFFDBFEE3);
  static const _accentGlow = Color(0xFF98F3B2);
  static const _borderPrimary = Color(0xFF19A055);
  static const _bgField = Color(0xFFFAFAFA);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _textDisabled = Color(0xFF6D6D6D);

  @override
  void dispose() {
    _controller.dispose();
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
                    'phone_title',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ).tr(),
                  const SizedBox(height: 8),
                  const Text(
                    'phone_subtitle',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14, color: _textSecondary),
                  ).tr(),
                  const SizedBox(height: 28),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Text(
                      'phone_label',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ).tr(),
                  ),
                  const SizedBox(height: 6),
                  _PhoneField(controller: _controller),
                  const SizedBox(height: 6),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Text(
                      'phone_helper',
                      style: TextStyle(fontSize: 12, color: _textDisabled),
                    ).tr(),
                  ),
                ],
              ),
            ),
            _CtaBar(
              onPressed: () => context.goNamed(RouteNames.otp),
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
              color: _PhonePageState._textPrimary,
            ),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _PhonePageState._bgField,
        border: Border.all(color: _PhonePageState._borderPrimary),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: _PhonePageState._accentFocusRing,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  hintText: '55 123 4567',
                  hintStyle:
                      TextStyle(color: _PhonePageState._textDisabled, fontSize: 14),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 14, color: _PhonePageState._textPrimary),
              ),
            ),
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _PhonePageState._bgField,
              border: Border(
                left: BorderSide(color: Color(0xFFE5E5E5)),
              ),
            ),
            child: const Text(
              '+966',
              style:
                  TextStyle(fontSize: 14, color: _PhonePageState._textDisabled),
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaBar extends StatelessWidget {
  const _CtaBar({required this.onPressed});
  final VoidCallback onPressed;

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
              boxShadow: const [
                BoxShadow(
                  color: _PhonePageState._accentGlow,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _PhonePageState._accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: const Text(
                'phone_cta',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ).tr(),
            ),
          ),
        ),
      ),
    );
  }
}
