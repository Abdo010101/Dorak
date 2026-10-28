import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';
import 'app_back_button.dart';

/// Thin wrapper around Material `AppBar` enforcing DS tokens.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.centerTitle = true,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final typo = AppTypography.of(context);
    final colors = AppColorsTheme.of(context);
    return AppBar(
      leading: showBack ? AppBackButton(onPressed: onBack) : null,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: typo.titleSm.copyWith(color: colors.textPrimary),
      ),
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
