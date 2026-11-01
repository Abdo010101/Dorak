import 'package:dorakpattient/core/state/status.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../../../data/models/response/doctor_profile_response.dart';
import '../../logic/doctor_profile_cubit.dart';
import '../../logic/doctor_profile_state.dart';

/// Phase 8 — Doctor profile (Figma `204:2053`, variants `363:3494`, `363:3625`).
///
/// RTL-first. Wires [DoctorProfileCubit] → `GET /patient/doctors/{id}` and
/// renders the new `profile` sub-block (headline, rating, experience_years,
/// patients_count, bio, branches, services, is_favorite). Heart toggles
/// the doctor favorite via [DoctorProfileCubit.toggleFavorite].
class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key, this.doctorId = 1});

  final int doctorId;

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DoctorProfileCubit>().load(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
            builder: (context, s) {
              return Column(
                children: [
                  _TopBar(
                    isFavorite: s.isFavorite,
                    onBack: () => context.canPop() ? context.pop() : null,
                    onToggleFavorite: () =>
                        context.read<DoctorProfileCubit>().toggleFavorite(),
                  ),
                  Expanded(child: _Content(state: s)),
                  _BookingBar(
                    onBook: () async {
                      if (!await ensureSignedIn(context)) return;
                      if (!context.mounted) return;
                      context.pushNamed(RouteNames.bookingSpecialtyDoctor);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isFavorite,
    required this.onBack,
    required this.onToggleFavorite,
  });
  final bool isFavorite;
  final VoidCallback? onBack;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          AppBackButton(onPressed: onBack),
          Expanded(
            child: Center(
              child: Text(
                'doctor_profile'.tr(),
                style: typo.titleSm.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? const Color(0xFFB42318) : colors.textPrimary,
            ),
            onPressed: onToggleFavorite,
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state});
  final DoctorProfileState state;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final colors = AppColorsTheme.of(context);
    if (state.status == Status.loading && state.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final profile = state.profile?.profile;
    final doctor = state.profile?.doctor;
    if (profile == null && doctor == null) {
      return Center(
        child: Text(
          state.errorMessage ?? 'something_went_wrong'.tr(),
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg,
        0,
        spacing.lg,
        spacing.lg,
      ),
      children: [
        _DoctorHeader(name: doctor?.name ?? '', headline: profile?.headline),
        SizedBox(height: spacing.lg),
        _StatsRow(profile: profile),
        if ((profile?.bio ?? '').isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          const _SectionTitle(keyName: 'doctor_about'),
          SizedBox(height: spacing.xs2),
          _BodyText(text: profile!.bio!),
        ],
        if ((profile?.branches ?? const []).isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          const _SectionTitle(keyName: 'doctor_locations'),
          SizedBox(height: spacing.sm),
          for (final b in profile!.branches!) ...[
            _CityCard(branch: b),
            SizedBox(height: spacing.xs2),
          ],
        ],
        if ((profile?.services ?? const []).isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          const _SectionTitle(keyName: 'doctor_price'),
          SizedBox(height: spacing.sm),
          for (final s in profile!.services!) ...[
            _ServiceRow(name: s),
            SizedBox(height: spacing.xs2),
          ],
        ],
        SizedBox(height: spacing.xxl),
      ],
    );
  }
}

class _DoctorHeader extends StatelessWidget {
  const _DoctorHeader({required this.name, required this.headline});
  final String name;
  final String? headline;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final spacing = AppSpacing.of(context);
    return Column(
      children: [
        const AppAvatar(size: 96, radius: 48),
        SizedBox(height: spacing.xs2),
        Text(
          name,
          style: typo.titleMd.copyWith(color: colors.textPrimary),
        ),
        if ((headline ?? '').isNotEmpty) ...[
          SizedBox(height: spacing.xs),
          Text(
            headline!,
            style: typo.textLgRegular.copyWith(color: colors.textSecondary),
          ),
        ],
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.profile});
  final DoctorProfile? profile;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final reviewers = (profile?.patientsCount ?? 0).toString();
    final experience = (profile?.experienceYears ?? 0).toString();
    final ratingValue = profile?.rating ?? '0';
    final ratingCount = (profile?.ratingsCount ?? 0).toString();
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.groups_outlined,
            value: reviewers,
            label: 'doctor_stat_reviewers'.tr(),
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: _StatTile(
            icon: Icons.verified_outlined,
            value: 'doctor_stat_experience_years'.tr(args: [experience]),
            label: 'doctor_stat_experience'.tr(),
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: _StatTile(
            icon: Icons.star_outline_rounded,
            value: ratingValue,
            label: 'doctor_stat_rating'.tr(args: [ratingCount]),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.icon, required this.value, required this.label});
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
          Text(value, style: typo.titleSm.copyWith(color: colors.textPrimary)),
          SizedBox(height: spacing.xs),
          Text(label,
              style: typo.textMdRegular.copyWith(color: colors.textSecondary)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.keyName});
  final String keyName;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        keyName.tr(),
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
      textAlign: TextAlign.start,
      style: typo.textLgRegular.copyWith(color: colors.textSecondary),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.branch});
  final String branch;

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
          Expanded(
            child: Text(branch,
                style: typo.titleSm.copyWith(color: colors.textPrimary)),
          ),
          SizedBox(width: spacing.md - 2),
          Icon(Icons.location_on_outlined,
              size: 20, color: colors.borderPrimary),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.name});
  final String name;

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
      child: Text(
        name,
        style: typo.textLgSemibold.copyWith(color: colors.textPrimary),
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
          spacing.lg,
          spacing.md,
          spacing.lg,
          spacing.sm,
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
