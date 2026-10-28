import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.thickness = 1,
  });

  final double indent;
  final double endIndent;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Divider(
      color: colors.fieldBorder,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      height: thickness,
    );
  }
}
