import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/state/status.dart';
import '../../../../core/theme/app_colors_theme.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../domain/entities/center_entity.dart';
import '../cubit/center_details_cubit.dart';
import '../cubit/center_details_state.dart';
import '../widgets/center_about_row.dart';
import '../widgets/center_booking_bar.dart';
import '../widgets/center_info_row.dart';
import '../widgets/center_offers_section.dart';
import '../widgets/center_reviews_section.dart';
import '../widgets/center_specialties_section.dart';

/// Center Details — Figma `175:861`.
/// RTL-first; data from `CenterDetailsCubit`.
class CenterDetailsPage extends StatefulWidget {
  const CenterDetailsPage({super.key, this.centerId = 1});
  final int centerId;

  @override
  State<CenterDetailsPage> createState() => _CenterDetailsPageState();
}

class _CenterDetailsPageState extends State<CenterDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CenterDetailsCubit>().load(widget.centerId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: BlocBuilder<CenterDetailsCubit, CenterDetailsState>(
          builder: (context, state) {
            if (state.status == Status.loading || state.center == null) {
              return const AppLoadingState();
            }
            final center = state.center!;
            return Column(
              children: [
                _TopBar(title: center.name),
                Expanded(child: _Content(center: center)),
                CenterBookingBar(
                  primaryLabel: 'center_book_cta'.tr(),
                  onPrimary: () {},
                  secondaryLabel: 'center_doctors_cta'.tr(),
                  onSecondary: () =>
                      context.push(RouteNames.doctorsAtCenter),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: colors.textPrimary),
            onPressed: () {},
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: typo.titleSm.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
          const AppBackButton(),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.center});
  final CenterEntity center;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final radii = AppRadii.of(context);
    final colors = AppColorsTheme.of(context);
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg, 0, spacing.lg, spacing.lg,
      ),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radii.medium),
          child: Image.asset(
            center.heroImageAsset,
            height: 189,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 189,
              color: colors.neutral50,
            ),
          ),
        ),
        SizedBox(height: spacing.xl),
        CenterInfoRow(
          titleKey: 'center_address_title',
          address: center.address,
          distanceKm: center.distanceKm,
        ),
        SizedBox(height: spacing.xl),
        CenterAboutRow(
          titleKey: 'center_about_title',
          body: center.about,
        ),
        SizedBox(height: spacing.xl),
        CenterSpecialtiesSection(specialties: center.specialties),
        SizedBox(height: spacing.xl),
        CenterOffersSection(
          titleKey: 'center_offers_title',
          offers: center.offers,
        ),
        SizedBox(height: spacing.xl),
        CenterReviewsSection(
          titleKey: 'center_reviews_title',
          reviews: center.reviews,
        ),
        SizedBox(height: spacing.xl),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text('center_location_title'.tr(),
              style: AppTypography.of(context)
                  .titleSm
                  .copyWith(color: colors.textPrimary)),
        ),
        SizedBox(height: spacing.lg),
        AppMapPreview(
          pinLabel: center.pinLabel,
          openMapLabel: 'center_open_map'.tr(),
        ),
        SizedBox(height: spacing.xl),
      ],
    );
  }
}
