import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDisabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final typo = AppTypography.of(context);
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      child: Text(label, style: typo.textLgSemibold),
    );
  }
}
