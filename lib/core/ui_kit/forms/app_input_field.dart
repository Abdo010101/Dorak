import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_typography.dart';

/// Dorak input field. 44 px tall, 12 px radius, filled with `surfaceField`.
///
/// States:
/// - default : 1 px `fieldBorder`
/// - focus   : 1 px `borderPrimary` + 3 px `focusRing` glow
/// - error   : 1 px `borderWarning`  + 3 px `errorRing`  glow
/// - disabled: `neutral50` fill, muted text
///
/// Figma: Account 09 inputs (`209:3095 / 209:3101 / 209:3111`).
/// Layout is directional. Pass [forceLtr] for fields that must always read
/// left-to-right regardless of app locale (phone numbers, dial codes, OTP).
class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.helperText,
    this.errorText,
    this.successText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.leading,
    this.trailing,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
    this.inputFormatters,
    this.textAlign,
    this.textDirection,
    this.forceLtr = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? helperText;
  final String? errorText;
  final String? successText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool forceLtr;
  final bool autofocus;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  FocusNode? _ownedFocus;
  bool _focused = false;

  FocusNode get _effectiveFocus =>
      widget.focusNode ?? (_ownedFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveFocus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant AppInputField old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      old.focusNode?.removeListener(_onFocusChange);
      _effectiveFocus.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocus.removeListener(_onFocusChange);
    _ownedFocus?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!mounted) return;
    final f = _effectiveFocus.hasFocus;
    if (f != _focused) setState(() => _focused = f);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final disabled = !widget.enabled;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final hasValid =
        widget.successText != null && widget.successText!.isNotEmpty;

    final Color borderColor;
    final Color ringColor;
    if (disabled) {
      borderColor = colors.fieldBorder;
      ringColor = Colors.transparent;
    } else if (hasError) {
      borderColor = colors.borderWarning;
      ringColor = colors.errorRing;
    } else if (hasValid) {
      borderColor = colors.borderSuccess;
      ringColor = colors.successRing;
    } else if (_focused) {
      borderColor = colors.borderPrimary;
      ringColor = colors.focusRing;
    } else {
      borderColor = colors.fieldBorder;
      ringColor = Colors.transparent;
    }

    Widget inputRow = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      height: 44,
      decoration: BoxDecoration(
        color: disabled ? colors.neutral50 : colors.white,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(radii.medium),
        boxShadow: ringColor == Colors.transparent
            ? null
            : [BoxShadow(color: ringColor, spreadRadius: 3)],
      ),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _effectiveFocus,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: widget.obscureText,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              maxLength: widget.maxLength,
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              autofocus: widget.autofocus,
              textAlign: widget.textAlign ?? TextAlign.start,
              textDirection: widget.textDirection,
              cursorColor: colors.borderPrimary,
              decoration: InputDecoration(
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
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: widget.hintText,
                hintStyle: typo.textLgRegular.copyWith(
                  color: colors.textSecondary.withValues(alpha: .6),
                ),
              ),
              style: typo.textLgRegular.copyWith(
                color: disabled ? colors.textSecondary : colors.textPrimary,
              ),
            ),
          ),
          if (widget.trailing != null) ...[
            const SizedBox(width: 10),
            widget.trailing!,
          ],
        ],
      ),
    );
    if (widget.forceLtr) {
      inputRow =
          Directionality(textDirection: TextDirection.ltr, child: inputRow);
    }

    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typo.textMdSemibold.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 6),
        ],
        inputRow,
        if (hasError) ...[
          const SizedBox(height: 6),
          _MessageRow(
            icon: Icons.error_outline,
            text: widget.errorText!,
            color: colors.textWarning,
            typo: typo,
          ),
        ] else if (hasValid) ...[
          const SizedBox(height: 6),
          _MessageRow(
            icon: Icons.check_circle_outline,
            text: widget.successText!,
            color: colors.textSuccess,
            typo: typo,
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              widget.helperText!,
              textAlign: TextAlign.start,
              style: typo.textMdRegular.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ],
    );

    return field;
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({
    required this.icon,
    required this.text,
    required this.color,
    required this.typo,
  });
  final IconData icon;
  final String text;
  final Color color;
  final AppTypography typo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: typo.textMdRegular.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
