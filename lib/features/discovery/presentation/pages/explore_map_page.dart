import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/centers_response.dart';
import 'package:dorakpattient/features/discovery/data/mock/discovery_centers_mock.dart';
import 'package:dorakpattient/features/discovery/logic/discovery_cubit.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Figma `203:1881` — Explore map view. Backs onto
/// `GET /patient/explore/map` via [DiscoveryCubit] (scope §10.1.5).
///
/// Pins project through the mock [DiscoveryCentersMock.bounds] viewport
/// because the UI does not ship a real tile renderer; swap for a real map
/// in a later ticket.
class ExploreMapPage extends StatefulWidget {
  const ExploreMapPage({super.key});

  @override
  State<ExploreMapPage> createState() => _ExploreMapPageState();
}

class _ExploreMapPageState extends State<ExploreMapPage> {
  int _selectedIndex = 0;
  String? _selectedSpecialtyKey;
  String? _selectedSpecialtyLabel;
  int? _selectedSpecialtyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DiscoveryCubit>().loadMap();
    });
  }

  Future<void> _openSpecialtySheet() async {
    final picked = await AllSpecialtiesSheet.show(
      context,
      selectedKey: _selectedSpecialtyKey,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedSpecialtyKey = picked.key;
        _selectedSpecialtyLabel = picked.labelKey.tr();
        _selectedSpecialtyId = int.tryParse(picked.key);
        _selectedIndex = 0;
      });
      context.read<DiscoveryCubit>().loadMap(
            specializationId: _selectedSpecialtyId,
          );
    }
  }

  void _openDetails(MedicalCenterCard pin) {
    final route = (pin.type == 'clinic')
        ? RouteNames.clinicDetails
        : RouteNames.centerDetails;
    context.push('$route?id=${pin.id ?? 0}');
  }

  List<MedicalCenterCard> _pinsFrom(DiscoveryState s) {
    return [
      for (final c in s.medicalCenters)
        if (c.lat != null && c.lng != null) c,
      for (final c in s.clinics)
        if (c.lat != null && c.lng != null) c,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
          builder: (context, s) {
            final pins = _pinsFrom(s);
            final hasPins = pins.isNotEmpty;
            final selected = hasPins
                ? pins[_selectedIndex.clamp(0, pins.length - 1)]
                : null;
            return Column(
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
                      if (s.mapStatus == Status.loading && pins.isEmpty)
                        const Center(child: CircularProgressIndicator()),
                      if (hasPins)
                        Positioned.fill(
                          child: LayoutBuilder(
                            builder: (ctx, c) {
                              final size = Size(c.maxWidth, c.maxHeight);
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  for (int i = 0; i < pins.length; i++)
                                    _positioned(
                                      LatLng(pins[i].lat!, pins[i].lng!),
                                      size,
                                      MapMarkerPin(
                                        label: pins[i].name ?? '',
                                        rating: pins[i].rating ?? '',
                                        selected: i == _selectedIndex,
                                        onTap: () => setState(
                                            () => _selectedIndex = i),
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
                      if (selected != null)
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: HorizontalCenterCard(
                            pin: _cardPin(selected),
                            onTap: () => _openDetails(selected),
                            onDetails: () => _openDetails(selected),
                            onCall: () {},
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// `HorizontalCenterCard` was built around the mock [DiscoveryCenterPin];
  /// we adapt a backend card into one shape so the widget keeps its API.
  DiscoveryCenterPin _cardPin(MedicalCenterCard c) {
    return DiscoveryCenterPin(
      id: c.id ?? 0,
      name: c.name ?? '',
      shortLabel: c.name ?? '',
      rating: c.rating ?? '',
      specialties: (c.specializations ?? const []).join(' · '),
      location: [c.city, c.area].whereType<String>().join(' · '),
      imageAsset: 'assets/images/home/center1.png',
      latLng: LatLng(c.lat!, c.lng!),
      availableToday: c.availableToday ?? true,
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
