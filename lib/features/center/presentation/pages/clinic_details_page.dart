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
import '../cubit/clinic_details_cubit.dart';
import '../cubit/clinic_details_state.dart';
import '../widgets/center_about_row.dart';
import '../widgets/center_booking_bar.dart';
import '../widgets/center_info_row.dart';
import '../widgets/center_offers_section.dart';
import '../widgets/center_reviews_section.dart';

/// Clinic Details — Figma `433:11943`.
class ClinicDetailsPage extends StatefulWidget {
  const ClinicDetailsPage({super.key, this.clinicId = 100});
  final int clinicId;

  @override
  State<ClinicDetailsPage> createState() => _ClinicDetailsPageState();
}

class _ClinicDetailsPageState extends State<ClinicDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClinicDetailsCubit>().load(widget.clinicId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
          builder: (context, state) {
            final phase = (state.status == Status.loading ||
                    state.clinic == null)
                ? AppViewPhase.loading
                : state.status == Status.failure
                    ? AppViewPhase.error
                    : AppViewPhase.success;
            return AppStatusView(
              phase: phase,
              errorMessage: state.errorMessage,
              onRetry: () =>
                  context.read<ClinicDetailsCubit>().load(widget.clinicId),
              builder: (_) {
                final clinic = state.clinic!;
                return Column(
                  children: [
                    _TopBar(
                      title: clinic.name,
                      isFavorite: state.isFavorite,
                      onToggleFavorite: () =>
                          context.read<ClinicDetailsCubit>().toggleFavorite(),
                    ),
                    Expanded(child: _Content(clinic: clinic)),
                    CenterBookingBar(
                      primaryLabel: 'clinic_book_cta'.tr(),
                      onPrimary: () =>
                          context.pushNamed(RouteNames.bookingDateTime),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.isFavorite,
    required this.onToggleFavorite,
  });
  final String title;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          const AppBackButton(),
          Expanded(
            child: Center(
              child: Text(
                title,
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
  const _Content({required this.clinic});
  final ClinicEntity clinic;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final radii = AppRadii.of(context);
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg,
        0,
        spacing.lg,
        spacing.lg,
      ),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radii.medium),
          child: (clinic.heroImageUrl != null &&
                  clinic.heroImageUrl!.isNotEmpty)
              ? Image.network(
                  clinic.heroImageUrl!,
                  height: 189,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    clinic.heroImageAsset,
                    height: 189,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 189,
                      color: colors.neutral50,
                    ),
                  ),
                )
              : Image.asset(
                  clinic.heroImageAsset,
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
          address: clinic.address,
          distanceKm: clinic.distanceKm,
        ),
        SizedBox(height: spacing.xl),
        CenterAboutRow(
          titleKey: 'clinic_about_title',
          body: clinic.about,
          icon: Icons.phone,
          leading: _CallButton(phone: clinic.phone),
        ),
        SizedBox(height: spacing.xl),
        CenterOffersSection(
          titleKey: 'clinic_offers_title',
          offers: clinic.offers,
        ),
        SizedBox(height: spacing.xl),
        CenterReviewsSection(
          titleKey: 'clinic_reviews_title',
          reviews: clinic.reviews,
        ),
        SizedBox(height: spacing.xl),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text('clinic_location_title'.tr(),
              style: typo.titleSm.copyWith(color: colors.textPrimary)),
        ),
        SizedBox(height: spacing.lg),
        AppMapPreview(
          pinLabel: clinic.pinLabel,
          openMapLabel: 'center_open_map'.tr(),
        ),
        SizedBox(height: spacing.xl),
      ],
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Material(
      color: colors.primaryTint,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(Icons.phone, size: 20, color: colors.borderPrimary),
        ),
      ),
    );
  }
}
