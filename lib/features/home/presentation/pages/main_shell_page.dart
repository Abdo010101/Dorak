import 'package:dorakpattient/features/home/presentation/pages/home_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/settings_page.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Phase 8 — Main shell with bottom nav (4 tabs). Mirrors Figma `171:682`.
///
/// Tab order follows Figma visual order (RTL): Account | Bookings | Discovery | Home.
/// Logical index: 0=Home, 1=Discovery, 2=Bookings, 3=Account.
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  static const _accent = Color(0xFF1F8046);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _borderTertiary = Color(0xFFE5E5E5);

  final _pages = const <Widget>[
    HomePage(),
    _StubTab(title: 'استكشف'),
    _StubTab(title: 'حجوزاتي'),
    SettingsPage(),
  ];

  final _tabs = const <_TabSpec>[
    _TabSpec(icon: 'nav_home.svg', labelKey: 'nav_home'),
    _TabSpec(icon: 'nav_discovery.svg', labelKey: 'nav_discover'),
    _TabSpec(icon: 'nav_calendar.svg', labelKey: 'nav_bookings'),
    _TabSpec(icon: 'nav_profile.svg', labelKey: 'nav_account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _borderTertiary)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D1D1D1D),
              offset: Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final active = i == _index;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _index = i),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        if (active)
                          Container(
                            width: 28,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Color(0xFF19A055),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(2),
                              ),
                            ),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/home/${_tabs[i].icon}',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                active ? _accent : _textSecondary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _tabs[i].labelKey.tr(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w500,
                                color: active ? _accent : _textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({required this.icon, required this.labelKey});
  final String icon;
  final String labelKey;
}

class _StubTab extends StatelessWidget {
  const _StubTab({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.white),
      body: Center(child: Text(title)),
    );
  }
}
