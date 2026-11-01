import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/centers_response.dart';
import 'package:dorakpattient/features/discovery/logic/discovery_cubit.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/all_specialties_sheet.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/explore_header.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/filter_pill.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/view_toggle.dart';
import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/section_header.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Figma `173:649` — Explore — استكشف. Wires [DiscoveryCubit] →
/// `/patient/explore/map` for the paired lists (centers + clinics, up to
/// 100 each, scope §10.1.5). Specialty filter re-queries the cubit.
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String? _selectedSpecialtyKey;
  String? _selectedSpecialtyLabel;
  int? _selectedSpecialtyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DiscoveryCubit>().loadCentersAndClinics();
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
      });
      context.read<DiscoveryCubit>().loadCentersAndClinics(
            specializationId: _selectedSpecialtyId,
          );
    }
  }

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
              child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
                builder: (context, s) => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    AppInputField(
                      readOnly: true,
                      onTap: () => context.goNamed(RouteNames.searchDoctor),
                      hintText: 'search_speciality'.tr(),
                      leading: const Icon(Icons.search, size: 20),
                    ),
                    const SizedBox(height: 16),
                    FilterPill(
                      label: _selectedSpecialtyLabel ??
                          'explore_specialty_filter'.tr(),
                      onTap: _openSpecialtySheet,
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
                    if (s.listStatus == Status.loading &&
                        s.medicalCenters.isEmpty &&
                        s.clinics.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      if (s.medicalCenters.isNotEmpty) ...[
                        SectionHeader(
                          title: 'home_nearest_centers'.tr(),
                          actionLabel:
                              '${s.medicalCenters.length} ${'search_results_label'.tr()}',
                          onAction: () {},
                        ),
                        const SizedBox(height: 16),
                        _CardsGrid(cards: s.medicalCenters, isClinic: false),
                        const SizedBox(height: 24),
                      ],
                      if (s.clinics.isNotEmpty) ...[
                        SectionHeader(
                          title: 'home_nearest_clinics'.tr(),
                          actionLabel:
                              '${s.clinics.length} ${'search_results_label'.tr()}',
                          onAction: () {},
                        ),
                        const SizedBox(height: 16),
                        _CardsGrid(cards: s.clinics, isClinic: true),
                      ],
                      if (s.medicalCenters.isEmpty && s.clinics.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Text(
                            s.errorMessage ?? 'explore_empty'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF4C4C4C)),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardsGrid extends StatelessWidget {
  const _CardsGrid({required this.cards, required this.isClinic});
  final List<MedicalCenterCard> cards;
  final bool isClinic;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < cards.length; i += 2) {
      final left = cards[i];
      final right = i + 1 < cards.length ? cards[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
          child: Row(
            children: [
              Expanded(child: _cardFrom(left, isClinic: isClinic)),
              const SizedBox(width: 8),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _cardFrom(right, isClinic: isClinic),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _cardFrom(MedicalCenterCard c, {required bool isClinic}) {
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
      imageAsset:
          isClinic ? 'assets/images/home/center2.png' : 'assets/images/home/center1.png',
    );
  }
}
