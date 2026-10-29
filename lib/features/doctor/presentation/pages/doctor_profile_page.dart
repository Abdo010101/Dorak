import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';

/// Phase 8 — Doctor profile (Figma `204:2053`, variants `363:3494`, `363:3625`).
///
/// RTL-first. Data from static mock keyed by [doctorId] until
/// `DoctorProfileCubit` wiring returns real `DoctorProfileResponse` for every
/// doctor the backend serves.
class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key, this.doctorId = 1});

  final int doctorId;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final data = _doctorMock(doctorId);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => context.canPop() ? context.pop() : null),
            Expanded(child: _Content(data: data)),
            _BookingBar(
              onBook: () async {
                if (!await ensureSignedIn(context)) return;
                if (!context.mounted) return;
                context.pushNamed(RouteNames.bookingSpecialtyDoctor);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorMock {
  const _DoctorMock({
    required this.name,
    required this.subtitle,
    required this.about,
    required this.reviewersCount,
    required this.experienceYears,
    required this.ratingValue,
    required this.ratingCount,
    required this.cities,
    required this.priceLabel,
    required this.serviceName,
  });

  static const String avatarAsset = 'assets/images/doctor/avatar.png';

  final String name;
  final String subtitle;
  final String about;
  final String reviewersCount;
  final String experienceYears;
  final String ratingValue;
  final String ratingCount;
  final List<_CityBranch> cities;
  final String priceLabel;
  final String serviceName;
}

class _CityBranch {
  const _CityBranch({required this.city, required this.branches});
  final String city;
  final String branches;
}

_DoctorMock _doctorMock(int id) {
  switch (id) {
    case 2:
      return const _DoctorMock(
        name: 'د. سارة الحسن',
        subtitle: 'أخصائية طب الأسنان · مجمع النور الطبي',
        about: 'أخصائية طب أسنان عام وتجميلي، تهتم براحة المراجع ووضوح خطة العلاج.',
        reviewersCount: '+٣٠٠',
        experienceYears: '٨',
        ratingValue: '٤٫٧',
        ratingCount: '٩٨',
        cities: [_CityBranch(city: 'الدمام', branches: 'فرع الفيصلية')],
        priceLabel: '١٥٠',
        serviceName: 'كشف واستشارة أسنان',
      );
    case 3:
      return const _DoctorMock(
        name: 'د. منى الزهراني',
        subtitle: 'استشارية طب الأطفال · مجمع النور الطبي',
        about:
            'استشارية طب الأطفال وحديثي الولادة، بخبرة طويلة في متابعة نمو الأطفال.',
        reviewersCount: '+٨٠٠',
        experienceYears: '١٥',
        ratingValue: '٤٫٩',
        ratingCount: '١٥٤',
        cities: [_CityBranch(city: 'الدمام', branches: 'فرع الفيصلية')],
        priceLabel: '١٨٠',
        serviceName: 'كشف واستشارة أطفال',
      );
    case 1:
    default:
      return const _DoctorMock(
        name: 'د. أحمد العلي',
        subtitle: 'استشاري طب الأسنان · مجمع النور الطبي',
        about:
            'استشاري في طب وجراحة الأسنان، متخصص في التجميل وعلاج العصب، ويهتم بتجربة مريحة لكل مراجع.',
        reviewersCount: '+٥٠٠',
        experienceYears: '١٢',
        ratingValue: '٤٫٨',
        ratingCount: '٥٠٠',
        cities: [
          _CityBranch(city: 'الخبر', branches: 'فرع العقربية'),
          _CityBranch(city: 'الدمام', branches: 'فرع الفيصلية · فرع الشاطئ'),
        ],
        priceLabel: '١٥٠',
        serviceName: 'كشف واستشارة أسنان',
      );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/doctor/heart.svg',
              width: 24,
              height: 24,
              placeholderBuilder: (_) =>
                  Icon(Icons.favorite_border, color: colors.textPrimary),
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Center(
              child: Text(
                'doctor_profile'.tr(),
                style: typo.titleSm.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
          AppBackButton(onPressed: onBack),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.data});
  final _DoctorMock data;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg, 0, spacing.lg, spacing.lg,
      ),
      children: [
        _DoctorHeader(data: data),
        SizedBox(height: spacing.lg),
        _StatsRow(data: data),
        SizedBox(height: spacing.xl),
        const _SectionTitle(key_: 'doctor_about'),
        SizedBox(height: spacing.xs2),
        _BodyText(text: data.about),
        SizedBox(height: spacing.xl),
        const _SectionTitle(key_: 'doctor_locations'),
        SizedBox(height: spacing.sm),
        Row(
          children: [
            for (int i = 0; i < data.cities.length; i++) ...[
              if (i > 0) SizedBox(width: spacing.sm),
              Expanded(child: _CityCard(info: data.cities[i])),
            ],
          ],
        ),
        SizedBox(height: spacing.xl),
        const _SectionTitle(key_: 'doctor_price'),
        SizedBox(height: spacing.sm),
        _ServiceRow(name: data.serviceName, price: data.priceLabel),
        SizedBox(height: spacing.xxl),
      ],
    );
  }
}

class _DoctorHeader extends StatelessWidget {
  const _DoctorHeader({required this.data});
  final _DoctorMock data;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            _DoctorMock.avatarAsset,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const AppAvatar(size: 96, radius: 48),
          ),
        ),
        SizedBox(height: spacing.xs2),
        Text(
          data.name,
          style: typo.titleMd.copyWith(color: colors.textPrimary),
        ),
        SizedBox(height: spacing.xs),
        Text(
          data.subtitle,
          style: typo.textLgRegular.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.data});
  final _DoctorMock data;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.groups_outlined,
            value: data.reviewersCount,
            label: 'doctor_stat_reviewers'.tr(),
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: _StatTile(
            icon: Icons.verified_outlined,
            value: 'doctor_stat_experience_years'
                .tr(args: [data.experienceYears]),
            label: 'doctor_stat_experience'.tr(),
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: _StatTile(
            icon: Icons.star_outline_rounded,
            value: data.ratingValue,
            label: 'doctor_stat_rating'.tr(args: [data.ratingCount]),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: spacing.md),
      decoration: BoxDecoration(
        color: colors.neutral25,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(radii.medium),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: colors.borderPrimary),
          SizedBox(height: spacing.xs),
          Text(value,
              style: typo.titleSm.copyWith(color: colors.textPrimary)),
          SizedBox(height: spacing.xs),
          Text(label,
              style: typo.textMdRegular
                  .copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.key_});
  final String key_;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Text(
        key_.tr(),
        style: typo.titleSm.copyWith(color: colors.textPrimary),
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Text(
      text,
      textAlign: TextAlign.end,
      style: typo.textLgRegular.copyWith(color: colors.textSecondary),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.info});
  final _CityBranch info;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.md, vertical: spacing.sm + 2),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(radii.medium),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 20, color: colors.borderPrimary),
          SizedBox(width: spacing.md - 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(info.city,
                    style: typo.titleSm.copyWith(color: colors.textPrimary)),
                SizedBox(height: spacing.xs - 2),
                Text(info.branches,
                    style: typo.textMdRegular
                        .copyWith(color: colors.textSecondary)),
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
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final radii = AppRadii.of(context);
    final spacing = AppSpacing.of(context);
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.lg - 2, vertical: spacing.md),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(radii.large),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'price_sar'.tr(args: [price]),
            style: typo.textLgSemibold.copyWith(
              color: colors.borderPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(name,
              style: typo.textLgSemibold.copyWith(color: colors.textPrimary)),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.onBook});
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          border: Border(
            top: BorderSide(color: colors.fieldBorder),
          ),
        ),
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing.lg, spacing.md, spacing.lg, spacing.sm,
        ),
        child: AppPrimaryButton(
          label: 'doctor_book_cta'.tr(),
          leadingIcon: Icon(Icons.calendar_today_outlined,
              size: 20, color: colors.onPrimary),
          onPressed: onBook,
        ),
      ),
    );
  }
}
