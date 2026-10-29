import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/services/location_service.dart';
import 'package:dorakpattient/core/ui_kit/feedback/location_opt_in_sheet.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _kickLocation());
  }

  Future<void> _kickLocation() async {
    if (!mounted) return;
    await context.read<GeneralCubit>().resolveDeviceLocation(
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
    await _kickLocation();
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
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'home_specialties'.tr(),
                    actionLabel: 'home_view_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),
                  const SpecialtyChipRow(
                    chips: [
                      SpecialtyChipData('الكل', true),
                      SpecialtyChipData('الأسنان', false),
                      SpecialtyChipData('الجلدية', false),
                      SpecialtyChipData('العيون', false),
                      SpecialtyChipData('الأطفال', false),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'home_latest_offers'.tr(),
                    actionLabel: 'home_view_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: OfferCard(
                          centerId: 2,
                          title: 'فحص البشرة',
                          centerName: 'مجمع النور الطبي',
                          price: '١٤٩',
                          imageAsset: 'assets/images/home/skin_offer.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: OfferCard(
                          centerId: 1,
                          title: 'تنظيف الأسنان',
                          centerName: 'مركز العناية الطبي',
                          price: '١٩٩',
                          imageAsset: 'assets/images/home/dental_offer.png',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'home_nearest_centers'.tr(),
                    actionLabel: 'home_view_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: CenterCard(
                          centerId: 1,
                          name: 'مركز العناية الطبي',
                          specialties: 'الأسنان ، الجلدية',
                          location: 'الدمام · حي الفيصلية',
                          rating: '٤٫٨',
                          reviewCount: '(١٢٠)',
                          distance: '٢٫٤ كم',
                          imageAsset: 'assets/images/home/center1.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CenterCard(
                          centerId: 2,
                          name: 'مجمع النور الطبي',
                          specialties: 'الأسنان ، الجلدية',
                          location: 'الدمام · حي الفيصلية',
                          rating: '٤٫٨',
                          reviewCount: '(١٢٠)',
                          distance: '٢٫٤ كم',
                          imageAsset: 'assets/images/home/center2.png',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: CenterCard(
                          centerId: 3,
                          name: 'مركز الحياة الطبي',
                          specialties: 'العيون ، الجلدية',
                          location: 'الدمام · حي المزروعية',
                          rating: '٤٫٥',
                          reviewCount: '(١١٠)',
                          distance: '٣٫١ كم',
                          imageAsset: 'assets/images/home/center1.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CenterCard(
                          centerId: 4,
                          name: 'مجمع السلام الطبي',
                          specialties: 'الأطفال ، الباطنية',
                          location: 'الدمام · حي الشاطئ',
                          rating: '٤٫٦',
                          reviewCount: '(٩٨)',
                          distance: '٤٫٢ كم',
                          imageAsset: 'assets/images/home/center2.png',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'home_nearest_clinics'.tr(),
                    actionLabel: 'home_view_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: CenterCard(
                          centerId: 101,
                          isClinic: true,
                          name: 'عيادة الدكتور أحمد',
                          specialties: 'الأسنان',
                          location: 'الدمام · حي الفيصلية',
                          rating: '٤٫٨',
                          reviewCount: '(٥٠)',
                          distance: '١٫٨ كم',
                          imageAsset: 'assets/images/home/center1.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CenterCard(
                          centerId: 102,
                          isClinic: true,
                          name: 'عيادة الدكتورة سارة',
                          specialties: 'الجلدية',
                          location: 'الدمام · حي المزروعية',
                          rating: '٤٫٧',
                          reviewCount: '(٦٥)',
                          distance: '٢٫٥ كم',
                          imageAsset: 'assets/images/home/center2.png',
                        ),
                      ),
                    ],
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
          onTap: () => ctx.pushNamed(RouteNames.discoveryLocationPicker),
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
          onTap: _kickLocation,
        );
    }
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
