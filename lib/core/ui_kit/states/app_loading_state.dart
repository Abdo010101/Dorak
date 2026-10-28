import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';

/// Centered circular loading indicator for a page-level busy state.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.borderPrimary),
      ),
    );
  }
}
