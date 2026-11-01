import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/services/location_service.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/ui_kit/feedback/location_opt_in_sheet.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/models/response/home_response.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_state.dart';
import 'package:dorakpattient/features/home/logic/home_cubit.dart';
import 'package:dorakpattient/features/home/logic/home_state.dart';
import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/home_header.dart';
import 'package:dorakpattient/features/home/presentation/widgets/location_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/offer_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/section_header.dart';
import 'package:dorakpattient/features/home/presentation/widgets/specialty_chip_row.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Home — الرئيسية (Figma node `171:509`).
///
/// Static mock lists for now; location card is wired to [GeneralCubit] and
/// `LocationService` so the device location + reverse-geocoded city/area
/// drive what the card shows.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _sheetShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _kickLocation();
      if (!mounted) return;
      context.read<HomeCubit>().load();
    });
  }

  /// Resolve device location. By default this is a no-op when the cubit
  /// already has a terminal status, so navigating away from Home and coming
  /// back does not re-run the resolve. Pass `force: true` for the explicit
  /// tap-on-card retry.
  Future<void> _kickLocation({bool force = false}) async {
    if (!mounted) return;
    final cubit = context.read<GeneralCubit>();
    if (!force) {
      final s = cubit.state.locationStatus;
      if (s != LocationResolveStatus.idle) return;
    }
    await cubit.resolveDeviceLocation(
      svc: locator<LocationService>(),
      localeCode: context.locale.languageCode,
    );
  }

  Future<void> _maybeShowOptIn(LocationResolveStatus s) async {
    if (_sheetShown || !mounted) return;
    final variant = s == LocationResolveStatus.deniedForever
        ? LocationOptInVariant.settings
        : LocationOptInVariant.allow;
    _sheetShown = true;
    final confirmed = await LocationOptInSheet.show(context, variant: variant);
    if (!mounted) return;
    if (!confirmed) return;
    if (variant == LocationOptInVariant.settings) {
      await locator<LocationService>().openSystemSettings();
      return;
    }
    _sheetShown = false;
    await _kickLocation(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HomeHeader(
              greeting: 'أهلا فيك',
              subtitle: 'موعدك المناسب بانتظارك',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  BlocConsumer<GeneralCubit, GeneralState>(
                    listenWhen: (prev, cur) =>
                        prev.locationStatus != cur.locationStatus,
                    listener: (ctx, s) {
                      if (s.locationStatus == LocationResolveStatus.denied ||
                          s.locationStatus ==
                              LocationResolveStatus.deniedForever) {
                        _maybeShowOptIn(s.locationStatus);
                      }
                    },
                    buildWhen: (prev, cur) =>
                        prev.locationStatus != cur.locationStatus ||
                        prev.resolvedCityName != cur.resolvedCityName ||
                        prev.resolvedAreaName != cur.resolvedAreaName,
                    builder: (ctx, s) => _buildLocationCard(ctx, s),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, s) => _HomeSections(state: s),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext ctx, GeneralState s) {
    final label = 'home_location_label'.tr();
    switch (s.locationStatus) {
      case LocationResolveStatus.idle:
      case LocationResolveStatus.loading:
        return LocationCard(
          label: label,
          value: 'home_location_loading'.tr(),
          trailingSpinner: true,
        );
      case LocationResolveStatus.resolved:
        final city = s.resolvedCityName ?? '';
        final area = s.resolvedAreaName ?? '';
        final sep = ctx.locale.languageCode == 'ar' ? '، ' : ', ';
        final value = [city, area]
            .where((e) => e.isNotEmpty)
            .join(sep)
            .ifEmpty('home_location_choose'.tr());
        return LocationCard(
          label: label,
          value: value,
          onTap: () => _kickLocation(force: true),
        );
      case LocationResolveStatus.serviceDisabled:
        return LocationCard(
          label: label,
          value: 'home_location_service_off'.tr(),
          onTap: () => locator<LocationService>().openSystemSettings(),
        );
      case LocationResolveStatus.denied:
      case LocationResolveStatus.deniedForever:
      case LocationResolveStatus.error:
        return LocationCard(
          label: label,
          value: 'home_location_choose'.tr(),
          onTap: () => _kickLocation(force: true),
        );
    }
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

/// Home sections fed by [HomeCubit] (`GET /patient/home`, scope §10.1.12):
/// specialties chips, latest_offers, nearest_medical_centers (4),
/// nearest_clinics (4). Falls back to a loading spinner on first fetch.
class _HomeSections extends StatelessWidget {
  const _HomeSections({required this.state});
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final home = state.home;
    if (home == null && state.status == Status.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final specs = home?.specializations ?? const [];
    final offers = home?.latestOffers ?? const [];
    final centers = home?.nearestMedicalCenters ?? const [];
    final clinics = home?.nearestClinics ?? const [];
    final doctors = home?.bestDoctors ?? const [];
    final locationKnown = home?.location != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        if (specs.isNotEmpty) ...[
          SectionHeader(
            title: 'home_specialties'.tr(),
            actionLabel: 'home_view_all'.tr(),
            onAction: () {},
          ),
          const SizedBox(height: 16),
          SpecialtyChipRow(
            chips: [
              for (int i = 0; i < specs.length; i++)
                SpecialtyChipData(specs[i].name ?? '', i == 0),
            ],
            onTap: (i) {
              final name = specs[i].name ?? '';
              if (name.isEmpty) return;
              context.pushNamed(
                RouteNames.resultOfSearch,
                queryParameters: {'q': name},
              );
            },
          ),
          const SizedBox(height: 24),
        ],
        SectionHeader(
          title: 'home_latest_offers'.tr(),
          actionLabel: 'home_view_all'.tr(),
          onAction: () {},
        ),
        const SizedBox(height: 16),
        if (offers.isNotEmpty)
          _TwoColumnGrid(
            items: offers,
            builder: (o) => OfferCard(
              centerId: 0,
              title: o.title ?? '',
              centerName: o.doctor?.name ?? '',
              price: (o.priceAfter ?? o.priceBefore ?? '').toString(),
              imageAsset: 'assets/images/home/dental_offer.png',
            ),
          )
        else
          _EmptySectionCard(message: 'home_empty_offers'.tr()),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'home_nearest_centers'.tr(),
          actionLabel: 'home_view_all'.tr(),
          onAction: () {},
        ),
        const SizedBox(height: 16),
        if (centers.isNotEmpty)
          _TwoColumnGrid(
            items: centers,
            builder: (c) => _cardFromPlace(c, isClinic: false),
          )
        else
          _EmptySectionCard(
            message: 'home_empty_centers'.tr(),
            hint: locationKnown ? null : 'home_empty_centers_hint'.tr(),
          ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'home_nearest_clinics'.tr(),
          actionLabel: 'home_view_all'.tr(),
          onAction: () {},
        ),
        const SizedBox(height: 16),
        if (clinics.isNotEmpty)
          _TwoColumnGrid(
            items: clinics,
            builder: (c) => _cardFromPlace(c, isClinic: true),
          )
        else
          _EmptySectionCard(
            message: 'home_empty_clinics'.tr(),
            hint: locationKnown ? null : 'home_empty_clinics_hint'.tr(),
          ),
        const SizedBox(height: 24),
        SectionHeader(
          title: 'home_best_doctors'.tr(),
          actionLabel: 'home_view_all'.tr(),
          onAction: () {},
        ),
        const SizedBox(height: 16),
        if (doctors.isEmpty)
          _EmptySectionCard(message: 'home_empty_doctors'.tr()),
      ],
    );
  }

  Widget _cardFromPlace(HomePlaceCard c, {required bool isClinic}) {
    return CenterCard(
      centerId: c.id ?? 0,
      isClinic: isClinic,
      name: c.name ?? '',
      specialties: (c.specializations ?? const []).join(' · '),
      location: [c.city, c.area].whereType<String>().join(' · '),
      rating: c.rating ?? '—',
      reviewCount: '(${c.ratingsCount ?? 0})',
      distance:
          c.distanceKm != null ? '${c.distanceKm!.toStringAsFixed(1)} km' : '',
      imageAsset: isClinic
          ? 'assets/images/home/center2.png'
          : 'assets/images/home/center1.png',
    );
  }
}

class _TwoColumnGrid<T> extends StatelessWidget {
  const _TwoColumnGrid({required this.items, required this.builder});
  final List<T> items;
  final Widget Function(T) builder;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
          child: Row(
            children: [
              Expanded(child: builder(left)),
              const SizedBox(width: 8),
              Expanded(
                child: right == null ? const SizedBox.shrink() : builder(right),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _EmptySectionCard extends StatelessWidget {
  const _EmptySectionCard({required this.message, this.hint});

  final String message;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 24, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(
                hint!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
