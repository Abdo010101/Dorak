import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/explore_header.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/filter_pill.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/pill_search_bar.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/view_toggle.dart';
import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/offer_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/section_header.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Figma `173:649` — Explore — استكشف (AR). List default; map opens
/// `ExploreMapPage` via `RouteNames.discoveryExploreMap`.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ExploreHeader(
              title: 'explore_title'.tr(),
              city: 'explore_city'.tr(),
              onCityTap: () =>
                  context.push(RouteNames.discoveryLocationPicker),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  PillSearchBar(
                    readOnly: true,
                    onTap: () => context.goNamed(RouteNames.searchDoctor),
                  ),
                  const SizedBox(height: 16),
                  FilterPill(
                    label: 'explore_specialty_filter'.tr(),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  ViewToggle(
                    value: DiscoveryView.list,
                    mapLabel: 'explore_view_map'.tr(),
                    listLabel: 'explore_view_list'.tr(),
                    onChanged: (v) {
                      if (v == DiscoveryView.map) {
                        context.push(RouteNames.discoveryExploreMap);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'home_nearest_centers'.tr(),
                    actionLabel: '4 ${'search_results_label'.tr()}',
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: CenterCard(
                          name: 'مجمع النور الطبي',
                          specialties: 'الأسنان ، الجلدية',
                          location: 'الدمام · حي الفيصلية',
                          rating: '٤٫٨',
                          reviewCount: '(١٢٠)',
                          distance: '٢٫٤ كم',
                          imageAsset: 'assets/images/home/center2.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CenterCard(
                          name: 'مركز العناية الطبي',
                          specialties: 'الأسنان ، الجلدية',
                          location: 'الدمام · حي الشاطئ',
                          rating: '٤٫٨',
                          reviewCount: '(١٢٠)',
                          distance: '٢٫٤ كم',
                          imageAsset: 'assets/images/home/center1.png',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: CenterCard(
                          name: 'مركز الحياة الطبي',
                          specialties: 'العيون ، الجلدية',
                          location: 'الدمام · حي المزروعية',
                          rating: '٤٫٥',
                          reviewCount: '(١١٠)',
                          distance: '٣٫١ كم',
                          imageAsset: 'assets/images/home/center2.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: CenterCard(
                          name: 'مجمع السلام الطبي',
                          specialties: 'الأطفال',
                          location: 'الدمام · حي الفيصلية',
                          rating: '٤٫٦',
                          reviewCount: '(٨٠)',
                          distance: '٣٫٠ كم',
                          imageAsset: 'assets/images/home/center1.png',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'home_nearest_clinics'.tr(),
                    actionLabel: '2 ${'search_results_label'.tr()}',
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: CenterCard(
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
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'explore_offer_title'.tr(),
                    actionLabel: 'home_view_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  const OfferCard(
                    title: 'فحص البشرة',
                    centerName: 'مجمع النور الطبي',
                    price: '١٤٩',
                    imageAsset: 'assets/images/home/skin_offer.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
