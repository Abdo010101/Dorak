import 'package:dorakpattient/core/router/route_names.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Account 06 Profile signed-in (Figma `209:2649`).
///
/// Material icons stand in for Figma Hicon icons on list rows (same shape,
/// Primary-25 green pill, chevron-left). Avatar uses initial fallback.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _accent = Color(0xFF1F8046);
  static const _accentBg = Color(0xFFEFFFF3);
  static const _borderTertiary = Color(0xFFE5E5E5);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _textError = Color(0xFFB42318);
  static const _bgError = Color(0xFFFEF3F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
          children: [
            Text(
              'profile_title'.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            const _UserCard(name: 'سارة أحمد', phone: '+966 55 123 4567', initial: 'س'),
            const SizedBox(height: 14),
            const _SectionLabel('profile_section_account'),
            const SizedBox(height: 8),
            _ListGroup(
              rows: [
                _ListRowSpec(
                  icon: Icons.person_outline,
                  label: 'profile_personal_info',
                  onTap: () {},
                ),
                _ListRowSpec(
                  icon: Icons.calendar_today_outlined,
                  label: 'nav_bookings',
                  onTap: () => context.goNamed(RouteNames.appointments),
                ),
                _ListRowSpec(
                  icon: Icons.favorite_border,
                  label: 'profile_favorite_centers',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _SectionLabel('profile_section_preferences'),
            const SizedBox(height: 8),
            _ListGroup(
              rows: [
                _ListRowSpec(
                  icon: Icons.notifications_none,
                  label: 'profile_notifications',
                  trailingValue: 'profile_enabled',
                  onTap: () {},
                ),
                _ListRowSpec(
                  icon: Icons.language,
                  label: 'profile_language',
                  trailingValue: 'profile_language_value',
                  onTap: () => context.goNamed(RouteNames.language),
                ),
                _ListRowSpec(
                  icon: Icons.location_on_outlined,
                  label: 'profile_city',
                  trailingValue: 'profile_city_value',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 14),
            _ListGroup(
              rows: [
                _ListRowSpec(
                  icon: Icons.help_outline,
                  label: 'profile_help_support',
                  onTap: () {},
                ),
                _ListRowSpec(
                  icon: Icons.logout,
                  label: 'profile_logout',
                  isDestructive: true,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.phone, required this.initial});
  final String name;
  final String phone;
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProfilePage._accentBg,
        border: Border.all(color: ProfilePage._borderTertiary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ProfilePage._borderTertiary),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.edit_outlined, size: 20, color: ProfilePage._textPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ProfilePage._textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ProfilePage._textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ProfilePage._accent,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.key_);
  final String key_;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Text(
        key_.tr(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ProfilePage._textSecondary,
        ),
      ),
    );
  }
}

class _ListRowSpec {
  const _ListRowSpec({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingValue,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailingValue;
  final bool isDestructive;
}

class _ListGroup extends StatelessWidget {
  const _ListGroup({required this.rows});
  final List<_ListRowSpec> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ProfilePage._borderTertiary),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1D1D1D),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final r = rows[i];
          return _ListRow(spec: r, hasDivider: i != rows.length - 1);
        }),
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  const _ListRow({required this.spec, required this.hasDivider});
  final _ListRowSpec spec;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    final chevron = Directionality.of(context) == TextDirection.rtl
        ? Icons.chevron_left
        : Icons.chevron_right;
    final titleColor =
        spec.isDestructive ? ProfilePage._textError : ProfilePage._textPrimary;
    final iconBg = spec.isDestructive ? ProfilePage._bgError : ProfilePage._accentBg;
    final iconColor = spec.isDestructive ? ProfilePage._textError : ProfilePage._accent;
    return InkWell(
      onTap: spec.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: hasDivider
              ? const Border(
                  bottom: BorderSide(color: ProfilePage._borderTertiary),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(chevron, size: 20, color: ProfilePage._textSecondary),
            if (spec.trailingValue != null) ...[
              const SizedBox(width: 8),
              Text(
                spec.trailingValue!.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  color: ProfilePage._textSecondary,
                ),
              ),
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  spec.label.tr(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(spec.icon, size: 20, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }
}
