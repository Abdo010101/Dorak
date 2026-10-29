import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_radii.dart';
import '../../theme/app_typography.dart';

/// Dorak Primary button. Figma DS `4034:148` (filled green).
///
/// Spec: 44 px Medium (default), 36 px Small, 32 px XSmall.
/// Radius 12. Padding 20 h / 12 v. Text 14 semibold on-color white.
/// Hover `#1C5E35`, Pressed `#103D20`, Disabled `#D2D2D2` bg + `#4C4C4C` text.
/// Default drop-shadow 0 1 5 glow `primary200 (#98F3B2)`.
///
/// Loading: button collapses to a circular pill with a spinner, then expands
/// back when `isLoading` goes false — 320 ms ease-in-out.
enum AppButtonSize { small, medium, xsmall }

class AppPrimaryButton extends StatefulWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.expand = true,
    this.size = AppButtonSize.medium,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final bool isDisabled;
  final bool expand;
  final AppButtonSize size;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton>
    with SingleTickerProviderStateMixin {
  static const _hovered = Color(0xFF1C5E35);
  static const _pressed = Color(0xFF103D20);
  static const _disabledBg = Color(0xFFD2D2D2);
  static const _disabledFg = Color(0xFF4C4C4C);
  static const _anim = Duration(milliseconds: 520);
  static const _curve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);

    final height = switch (widget.size) {
      AppButtonSize.medium => 44.0,
      AppButtonSize.small => 36.0,
      AppButtonSize.xsmall => 32.0,
    };
    final hPad = switch (widget.size) {
      AppButtonSize.medium => 20.0,
      AppButtonSize.small => 16.0,
      AppButtonSize.xsmall => 12.0,
    };

    final disabled = widget.isDisabled || widget.isLoading;
    final enabled = !disabled;

    final bg = widget.isDisabled
        ? _disabledBg
        : (widget.isLoading ? _pressed : colors.borderPrimary);
    final fg = widget.isDisabled ? _disabledFg : colors.onPrimary;

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return bg;
        if (states.contains(WidgetState.pressed)) return _pressed;
        if (states.contains(WidgetState.hovered)) return _hovered;
        return bg;
      }),
      foregroundColor: WidgetStatePropertyAll(fg),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return _pressed.withValues(alpha: .2);
        }
        return null;
      }),
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      padding: WidgetStatePropertyAll(
        widget.isLoading
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: hPad),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.isLoading ? height / 2 : radii.medium,
          ),
        ),
      ),
      textStyle: WidgetStatePropertyAll(typo.textLgSemibold),
      elevation: const WidgetStatePropertyAll(0),
      animationDuration: _anim,
    );

    final labelRow = Row(
      key: const ValueKey('label'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leadingIcon != null) ...[
          widget.leadingIcon!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: typo.textLgSemibold,
            overflow: TextOverflow.clip,
            softWrap: false,
            maxLines: 1,
          ),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: 8),
          widget.trailingIcon!,
        ],
      ],
    );

    final spinner = SizedBox(
      key: const ValueKey('spinner'),
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
      ),
    );

    final child = AnimatedSwitcher(
      duration: _anim,
      switchInCurve: _curve,
      switchOutCurve: _curve,
      transitionBuilder: (c, a) => FadeTransition(
        opacity: a,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.6, end: 1).animate(a),
          child: c,
        ),
      ),
      child: widget.isLoading ? spinner : labelRow,
    );

    final btn = FilledButton(
      onPressed: enabled ? widget.onPressed : null,
      style: style,
      child: ClipRect(child: child),
    );

    final decorated = enabled
        ? AnimatedContainer(
            duration: _anim,
            curve: _curve,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                widget.isLoading ? height / 2 : radii.medium,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.primary200,
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: btn,
          )
        : btn;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final maxW = constraints.hasBoundedWidth && widget.expand
            ? constraints.maxWidth
            : null;
        final targetW = widget.isLoading ? height : maxW;
        return SizedBox(
          height: height,
          width: widget.expand ? maxW : null,
          child: Align(
            alignment: AlignmentDirectional.center,
            child: AnimatedContainer(
              duration: _anim,
              curve: _curve,
              height: height,
              width: targetW,
              child: decorated,
            ),
          ),
        );
      },
    );
  }
}
