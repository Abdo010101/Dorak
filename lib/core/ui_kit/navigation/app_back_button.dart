import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';

/// RTL-aware back button.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return IconButton(
      icon: Icon(
        isRtl ? Icons.arrow_forward : Icons.arrow_back,
        color: colors.textPrimary,
      ),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
