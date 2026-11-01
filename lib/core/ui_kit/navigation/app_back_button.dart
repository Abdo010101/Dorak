import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';

/// RTL-aware back button.
///
/// Hides itself when there is nothing to pop and no explicit [onPressed]
/// is supplied, so top-level pages (home, splash, main shell) do not get
/// a dead arrow. If [onPressed] is provided, the button always renders.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    if (onPressed == null && !canPop) return const SizedBox.shrink();
    final colors = AppColorsTheme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return IconButton(
      icon: Icon(
        isRtl ? Icons.arrow_back : Icons.arrow_forward,
        color: colors.textPrimary,
      ),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
