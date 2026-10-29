import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/explore_header.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/filter_pill.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/map_background.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/map_marker.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/pill_search_bar.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/view_toggle.dart';
import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Figma `203:1881` — Explore map view.
class ExploreMapPage extends StatelessWidget {
  const ExploreMapPage({super.key});

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: PillSearchBar(
                readOnly: true,
                onTap: () => context.goNamed(RouteNames.searchDoctor),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilterPill(
                label: 'explore_specialty_filter'.tr(),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ViewToggle(
                value: DiscoveryView.map,
                mapLabel: 'explore_view_map'.tr(),
                listLabel: 'explore_view_list'.tr(),
                onChanged: (v) {
                  if (v == DiscoveryView.list) context.pop();
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: const [
                  Positioned.fill(child: MapBackground()),
                  PositionedDirectional(
                    top: 60,
                    start: 60,
                    child: MapMarker(label: 'النور', rating: '٤٫٦'),
                  ),
                  PositionedDirectional(
                    top: 110,
                    end: 60,
                    child: MapMarker(label: 'العناية', rating: '٤٫٨'),
                  ),
                  PositionedDirectional(
                    top: 210,
                    start: 100,
                    child: MapMarker(label: 'الحياة', rating: '٤٫٥'),
                  ),
                  PositionedDirectional(
                    top: 280,
                    start: 24,
                    child: MapMarker(label: 'عيادة أحمد', rating: '٤٫٨'),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: CenterCard(
                      name: 'مركز العناية الطبي',
                      specialties: 'الأسنان ، الجلدية',
                      location: 'الدمام · حي الفيصلية',
                      rating: '٤٫٨',
                      reviewCount: '(١٢٠)',
                      distance: '٢٫٤ كم',
                      imageAsset: 'assets/images/home/center1.png',
                    ),
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
