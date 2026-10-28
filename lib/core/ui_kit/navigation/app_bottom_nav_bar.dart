import 'package:flutter/material.dart';

import '../../theme/app_colors_theme.dart';
import '../../theme/app_typography.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// 4-tab bottom navigation per Figma Patient App.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.white,
      selectedItemColor: colors.borderPrimary,
      unselectedItemColor: const Color(0xFFA3A3A3),
      selectedLabelStyle: typo.textMdSemibold,
      unselectedLabelStyle: typo.textMdRegular,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        for (final item in items)
          BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label,
          ),
      ],
    );
  }
}
