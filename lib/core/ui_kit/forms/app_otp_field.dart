import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';

/// Dorak OTP input — DS node `4112:227` (OTP Cell).
///
/// Four 64×64 cells, 12 px radius. States per cell:
///  - Empty  : `neutral25` bg, 1 px `fieldBorder` ring
///  - Focused: `neutral25` bg, 1 px blue `#014AE0` ring + 4 px rgba(1,74,224,.08)
///             glow + green caret (`borderPrimary`)
///  - Filled : same chrome as Empty, 20 px Tajawal-Bold `textDisplay` digit
///  - Error  : `#FEF3F2` bg, 1 px `#B42318` ring + red digit
///
/// Auto-advances to the next cell on digit input; backspace clears + goes back.
/// Call [onCompleted] with the full code once every cell is filled.
class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    this.length = 4,
    this.hasError = false,
    this.onChanged,
    this.onCompleted,
    this.autofocus = true,
  });

  final int length;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;

  @override
  State<AppOtpField> createState() => AppOtpFieldState();
}

class AppOtpFieldState extends State<AppOtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) {
      final n = FocusNode();
      n.addListener(() {
        if (mounted) setState(() {});
      });
      return n;
    });
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNodes.first.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  /// Current code value (joined cell digits).
  String get code => _controllers.map((c) => c.text).join();

  /// Clears every cell and returns focus to the first one.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    widget.onChanged?.call('');
  }

  void _handle(int i, String v) {
    if (v.length > 1) {
      // paste
      final digits = v.replaceAll(RegExp(r'\D'), '');
      for (var j = 0; j < widget.length; j++) {
        _controllers[j].text = j < digits.length ? digits[j] : '';
      }
      final target =
          digits.length >= widget.length ? widget.length - 1 : digits.length;
      _focusNodes[target.clamp(0, widget.length - 1)].requestFocus();
    } else if (v.isNotEmpty && i < widget.length - 1) {
      _focusNodes[i + 1].requestFocus();
    } else if (v.isEmpty && i > 0) {
      _focusNodes[i - 1].requestFocus();
    }
    widget.onChanged?.call(code);
    if (code.length == widget.length &&
        !code.contains(RegExp(r'^\s*$'))) {
      widget.onCompleted?.call(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < widget.length; i++) ...[
            _OtpCell(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              hasError: widget.hasError,
              onChanged: (v) => _handle(i, v),
            ),
            if (i != widget.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  static const _focusRing = Color(0x14014AE0); // rgba(1,74,224,.08)
  static const _focusBorder = Color(0xFF014AE0);
  static const _errorBg = Color(0xFFFEF3F2);
  static const _errorBorder = Color(0xFFB42318);
  static const _displayText = Color(0xFF0C0C0C);

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final focused = focusNode.hasFocus;

    final Color bg;
    final Color border;
    final List<BoxShadow>? ring;
    if (hasError) {
      bg = _errorBg;
      border = _errorBorder;
      ring = null;
    } else if (focused) {
      bg = colors.neutral25;
      border = _focusBorder;
      ring = const [BoxShadow(color: _focusRing, spreadRadius: 4)];
    } else {
      bg = colors.neutral25;
      border = colors.fieldBorder;
      ring = null;
    }

    final digitColor = hasError ? _errorBorder : _displayText;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: ring,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        cursorColor: colors.borderPrimary,
        cursorWidth: 2,
        cursorHeight: 20,
        style: typo.titleMd.copyWith(
          color: digitColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          filled: false,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          isCollapsed: true,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
