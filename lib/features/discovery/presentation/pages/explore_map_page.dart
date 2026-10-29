import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/features/discovery/data/mock/discovery_centers_mock.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/all_specialties_sheet.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/explore_header.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/filter_pill.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/horizontal_center_card.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/map_background.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/map_marker_pin.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/pill_search_bar.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/view_toggle.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Figma `203:1881` — Explore map view. Centers carry lat/lng; pins project
/// through [DiscoveryCentersMock.bounds] into the viewport.
class ExploreMapPage extends StatefulWidget {
  const ExploreMapPage({super.key});

  @override
  State<ExploreMapPage> createState() => _ExploreMapPageState();
}

class _ExploreMapPageState extends State<ExploreMapPage> {
  int _selectedIndex = 0;
  String? _selectedSpecialtyKey;
  String? _selectedSpecialtyLabel;

  Future<void> _openSpecialtySheet() async {
    final picked = await AllSpecialtiesSheet.show(
      context,
      selectedKey: _selectedSpecialtyKey,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedSpecialtyKey = picked.key;
        _selectedSpecialtyLabel = picked.labelKey.tr();
      });
    }
  }

  void _openDetails(DiscoveryCenterPin pin) {
    context.push('${RouteNames.centerDetails}?id=${pin.id}');
  }

  @override
  Widget build(BuildContext context) {
    const pins = DiscoveryCentersMock.pins;
    final selected = pins[_selectedIndex];
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
                hint: 'explore_search_hint'.tr(),
                onTap: () => context.goNamed(RouteNames.searchDoctor),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilterPill(
                label: _selectedSpecialtyLabel ??
                    'explore_specialty_filter'.tr(),
                onTap: _openSpecialtySheet,
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
                children: [
                  const Positioned.fill(child: MapBackground()),
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (ctx, c) {
                        final size = Size(c.maxWidth, c.maxHeight);
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (int i = 0; i < pins.length; i++)
                              _positioned(
                                pins[i].latLng,
                                size,
                                MapMarkerPin(
                                  label: pins[i].shortLabel,
                                  rating: pins[i].rating,
                                  selected: i == _selectedIndex,
                                  onTap: () =>
                                      setState(() => _selectedIndex = i),
                                ),
                              ),
                            _positioned(
                              DiscoveryCentersMock.userLocation,
                              size,
                              const UserLocationDot(),
                              dotSize: 18,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: HorizontalCenterCard(
                      pin: selected,
                      onTap: () => _openDetails(selected),
                      onDetails: () => _openDetails(selected),
                      onCall: () {},
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

  Widget _positioned(
    LatLng p,
    Size size,
    Widget child, {
    double dotSize = 0,
  }) {
    final o = DiscoveryCentersMock.bounds.project(p, size);
    final half = dotSize / 2;
    return Positioned(
      left: o.dx - (dotSize == 0 ? 0 : half),
      top: o.dy - (dotSize == 0 ? 14 : half),
      child: FractionalTranslation(
        translation: dotSize == 0 ? const Offset(-0.5, 0) : Offset.zero,
        child: child,
      ),
    );
  }
}
