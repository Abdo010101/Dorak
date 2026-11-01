import 'dart:async';

import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/discovery_response.dart';
import 'package:dorakpattient/features/discovery/logic/discovery_cubit.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/confirm_location_sheet.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/map_background.dart';
import 'package:dorakpattient/features/discovery/presentation/widgets/pill_search_bar.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Figma `203:1600` — Discovery 02 Location picker. Wires
/// [DiscoveryCubit.searchLocations] (`GET /patient/locations?search=`,
/// scope §10.1.7). The confirmed selection pops back as a [LocationArea].
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  static const _accent = Color(0xFF1F8046);

  final TextEditingController _searchController = TextEditingController();
  Timer? _debouncer;
  LocationArea? _selected;

  @override
  void dispose() {
    _debouncer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.read<DiscoveryCubit>().searchLocations(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'discovery_location_title'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1D),
          ),
        ),
        leading: AppBackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            const Positioned.fill(child: MapBackground()),
            PositionedDirectional(
              top: 8,
              start: 16,
              end: 16,
              child: PillSearchBar(
                controller: _searchController,
                hint: 'discovery_my_location'.tr(),
                onChanged: _onSearchChanged,
              ),
            ),
            PositionedDirectional(
              top: 64,
              start: 16,
              end: 16,
              child: BlocBuilder<DiscoveryCubit, DiscoveryState>(
                builder: (context, s) {
                  if (s.areas.isEmpty) return const SizedBox.shrink();
                  return _AreaSuggestions(
                    areas: s.areas,
                    loading: s.areaStatus == Status.loading,
                    onPick: (a) {
                      setState(() => _selected = a);
                      _searchController.text = a.label ?? a.area ?? '';
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
            const Center(
              child: Icon(
                Icons.location_on,
                size: 48,
                color: _accent,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ConfirmLocationSheet(
                label: 'discovery_location_selected'.tr(),
                value: _selected?.label ??
                    _selected?.area ??
                    'discovery_location_value'.tr(),
                cta: AppPrimaryButton(
                  label: 'discovery_location_confirm'.tr(),
                  onPressed: () => context.pop(_selected),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaSuggestions extends StatelessWidget {
  const _AreaSuggestions({
    required this.areas,
    required this.loading,
    required this.onPick,
  });

  final List<LocationArea> areas;
  final bool loading;
  final ValueChanged<LocationArea> onPick;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 240),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: areas.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final a = areas[i];
            return ListTile(
              dense: true,
              leading: const Icon(Icons.place_outlined, size: 20),
              title: Text(a.label ?? a.area ?? ''),
              subtitle: a.city != null ? Text(a.city!) : null,
              onTap: () => onPick(a),
            );
          },
        ),
      ),
    );
  }
}
