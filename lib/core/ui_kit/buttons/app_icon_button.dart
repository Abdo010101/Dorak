import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isDisabled = false,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return IconButton(
      icon: IconTheme(
        data: IconThemeData(color: colors.textPrimary),
        child: icon,
      ),
      onPressed: isDisabled ? null : onPressed,
      tooltip: tooltip,
    );
  }
}
