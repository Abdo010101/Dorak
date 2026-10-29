import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/state/status.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../data/mock/center_mock.dart';
import '../cubit/doctors_at_center_cubit.dart';
import '../cubit/doctors_at_center_state.dart';
import '../widgets/doctor_at_center_card.dart';

/// Doctors at center — Figma `204:1933`.
class DoctorsAtCenterPage extends StatefulWidget {
  const DoctorsAtCenterPage({super.key, this.centerId = 1});
  final int centerId;

  @override
  State<DoctorsAtCenterPage> createState() => _DoctorsAtCenterPageState();
}

class _DoctorsAtCenterPageState extends State<DoctorsAtCenterPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorsAtCenterCubit>().load(widget.centerId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(
        title: 'center_doctors_cta'.tr(),
      ),
      body: SafeArea(
        top: false,
        child: BlocBuilder<DoctorsAtCenterCubit, DoctorsAtCenterState>(
          builder: (context, state) {
            if (state.status == Status.loading || state.center == null) {
              return const AppLoadingState();
            }
            final center = state.center!;
            final cubit = context.read<DoctorsAtCenterCubit>();
            final filtered = state.filteredDoctors;
            return ListView(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing.lg, spacing.lg, spacing.lg, spacing.xl,
              ),
              children: [
                AppBookingSummaryHeader(
                  title: center.name,
                  subtitle: 'center_doctors_summary'.tr(args: [
                    center.doctors.length.toString(),
                    center.specialties.length.toString(),
                  ]),
                  imageAsset: center.heroImageAsset,
                ),
                SizedBox(height: spacing.xl),
                _SpecialtyFilter(
                  selected: state.selectedSpecialty,
                  onSelect: cubit.setSpecialty,
                ),
                SizedBox(height: spacing.xl),
                _ListHeader(count: filtered.length),
                SizedBox(height: spacing.lg),
                for (int i = 0; i < filtered.length; i++) ...[
                  if (i > 0) SizedBox(height: spacing.lg),
                  DoctorAtCenterCard(
                    doctor: filtered[i],
                    onBook: () => context.push(
                      '${RouteNames.doctor}?id=${filtered[i].id}',
                    ),
                    onTap: () => context.push(
                      '${RouteNames.doctor}?id=${filtered[i].id}',
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SpecialtyFilter extends StatelessWidget {
  const _SpecialtyFilter({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final keys = CenterMock.specialtyFilterKeys;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: isRtl,
        itemCount: keys.length,
        separatorBuilder: (_, __) => SizedBox(width: spacing.sm),
        itemBuilder: (_, i) {
          final key = keys[i];
          return AppChoiceChip(
            label: CenterMock.specialtyLabels[key] ?? key,
            selected: key == selected,
            onTap: () => onSelect(key),
          );
        },
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'center_doctors_count'.tr(args: [count.toString()]),
          style: typo.textLgRegular.copyWith(color: colors.textSecondary),
        ),
        Text(
          'center_doctors_title'.tr(),
          style: typo.titleMd.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
