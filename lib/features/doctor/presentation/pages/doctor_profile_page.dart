import 'package:dorakpattient/core/router/route_names.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Center 03 Doctor profile (Figma `204:2053`).
///
/// Static mock data. `DoctorProfileCubit` wiring lands with the Phase 5
/// DoctorProfileController migration.
class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  static const _accent = Color(0xFF1F8046);
  static const _accentGlow = Color(0xFF98F3B2);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _borderTertiary = Color(0xFFE5E5E5);
  static const _bgNeutral25 = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => context.canPop() ? context.pop() : null),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: const [
                  _DoctorHeader(),
                  SizedBox(height: 16),
                  _StatsRow(),
                  SizedBox(height: 20),
                  _SectionTitle('doctor_about'),
                  SizedBox(height: 6),
                  Text(
                    'استشاري في طب وجراحة الأسنان، متخصص في التجميل وعلاج العصب، ويهتم بتجربة مريحة لكل مراجع.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  _SectionTitle('doctor_locations'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _CityCard(city: 'الخبر', branches: 'فرع العقربية')),
                      SizedBox(width: 8),
                      Expanded(child: _CityCard(city: 'الدمام', branches: 'فرع الفيصلية · فرع الشاطئ')),
                    ],
                  ),
                  SizedBox(height: 20),
                  _SectionTitle('doctor_price'),
                  SizedBox(height: 8),
                  _ServiceRow(name: 'كشف واستشارة أسنان', price: '١٥٠ ر.س'),
                  SizedBox(height: 32),
                ],
              ),
            ),
            const _BookingBar(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/doctor/heart.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Center(
              child: Text(
                'doctor_profile'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: DoctorProfilePage._textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 24,
              color: DoctorProfilePage._textPrimary,
            ),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

class _DoctorHeader extends StatelessWidget {
  const _DoctorHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/doctor/avatar.png',
            width: 96,
            height: 96,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'د. أحمد العلي',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: DoctorProfilePage._textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'استشاري طب الأسنان · مجمع النور الطبي',
          style: TextStyle(fontSize: 14, color: DoctorProfilePage._textSecondary),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatTile(icon: 'group.svg', value: '+٥٠٠', label: 'مراجع')),
        SizedBox(width: 8),
        Expanded(child: _StatTile(icon: 'shield_tick.svg', value: '١٢ سنة', label: 'خبرة')),
        SizedBox(width: 8),
        Expanded(child: _StatTile(icon: null, value: '٤٫٨', label: '(500 تقييم)')),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.value, required this.label});
  final String? icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: DoctorProfilePage._bgNeutral25,
        border: Border.all(color: DoctorProfilePage._borderTertiary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (icon != null)
            SvgPicture.asset('assets/images/doctor/$icon', width: 24, height: 24)
          else
            SvgPicture.asset('assets/images/home/star.svg', width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DoctorProfilePage._textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: DoctorProfilePage._textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.key_);
  final String key_;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        key_.tr(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: DoctorProfilePage._textPrimary,
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.city, required this.branches});
  final String city;
  final String branches;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DoctorProfilePage._borderTertiary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/home/location_icon.svg', width: 20, height: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DoctorProfilePage._textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  branches,
                  style: const TextStyle(
                    fontSize: 13,
                    color: DoctorProfilePage._textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.name, required this.price});
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DoctorProfilePage._borderTertiary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: DoctorProfilePage._accent,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: DoctorProfilePage._textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: DoctorProfilePage._borderTertiary),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: DoctorProfilePage._accentGlow,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Builder(
              builder: (ctx) => FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: DoctorProfilePage._accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => ctx.pushNamed(RouteNames.addAppointment),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/home/calendar.svg',
                    width: 20,
                    height: 20,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'doctor_book_cta'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
