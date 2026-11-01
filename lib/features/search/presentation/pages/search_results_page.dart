import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/centers_response.dart';
import 'package:dorakpattient/data/models/response/general_response.dart';
import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/specialty_chip_row.dart';
import 'package:dorakpattient/features/search/logic/search_cubit.dart';
import 'package:dorakpattient/features/search/logic/search_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Discovery 03 Search results (Figma `203:1690`) + 03b empty
/// (`352:3400`). Wires [SearchCubit] → `GET /patient/search` (scope §10.1.4),
/// renders the three buckets the backend returns: specialties chips +
/// medical centers + clinics (clinics show the doctor name as the card title).
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, this.initialQuery = ''});
  final String initialQuery;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _query =
      TextEditingController(text: widget.initialQuery);

  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);

  @override
  void initState() {
    super.initState();
    _query.addListener(_onQueryChanged);
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<SearchCubit>().setQuery(widget.initialQuery);
      });
    }
  }

  void _onQueryChanged() {
    if (!mounted) return;
    context.read<SearchCubit>().setQuery(_query.text);
    setState(() {}); // refresh clear-trailing icon
  }

  @override
  void dispose() {
    _query.removeListener(_onQueryChanged);
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              controller: _query,
              onCancel: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(RouteNames.home);
                }
              },
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, s) => _buildBody(context, s),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState s) {
    final q = _query.text.trim();
    if (q.isEmpty) {
      return const SizedBox.shrink();
    }
    if (s.status == Status.loading && s.result == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final r = s.result;
    final specs = r?.specializations ?? const <Titles>[];
    final centers = r?.medicalCenters?.data ?? const <MedicalCenterCard>[];
    final clinics = r?.clinics?.data ?? const <MedicalCenterCard>[];
    if ((r != null) &&
        specs.isEmpty &&
        centers.isEmpty &&
        clinics.isEmpty) {
      return _EmptyState(onClear: _query.clear);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (specs.isNotEmpty) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'search_specialties'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SpecialtyChipRow(
            chips: [
              for (final t in specs) SpecialtyChipData(t.name ?? '', false),
            ],
          ),
          const SizedBox(height: 16),
        ],
        // Centers section — always render the header so a 0-count is
        // readable to the user; cards appear only when there are rows.
        _listHeader(
          count: r?.medicalCenters?.total ?? centers.length,
          title: 'search_medical_centers'.tr(),
        ),
        const SizedBox(height: 12),
        if (centers.isNotEmpty)
          _cardsGrid(centers, isClinic: false)
        else
          _InlineEmpty(label: 'search_no_centers'.tr()),
        const SizedBox(height: 20),
        _listHeader(
          count: r?.clinics?.total ?? clinics.length,
          title: 'search_clinics'.tr(),
        ),
        const SizedBox(height: 12),
        if (clinics.isNotEmpty)
          _cardsGrid(clinics, isClinic: true)
        else
          _InlineEmpty(label: 'search_no_clinics'.tr()),
      ],
    );
  }

  Widget _cardsGrid(List<MedicalCenterCard> cards, {required bool isClinic}) {
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
      distance: c.distanceKm != null ? '${c.distanceKm!.toStringAsFixed(1)} km' : '',
      imageAsset: 'assets/images/home/center1.png',
    );
  }

  Widget _listHeader({required int count, required String title}) {
    // RTL: title pins to leading edge (right), count tail to trailing (left).
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          '$count ${'search_results_label'.tr()}',
          style: const TextStyle(fontSize: 14, color: _textSecondary),
        ),
      ],
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  const _InlineEmpty({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF4C4C4C)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 132,
            height: 132,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F7),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.search_off,
              size: 56,
              color: Color(0xFF9A9A9A),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'search_empty_title'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _SearchResultsPageState._textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'search_empty_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: _SearchResultsPageState._textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            child: AppPrimaryButton(
              label: 'search_empty_cta'.tr(),
              onPressed: onClear,
              expand: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller, required this.onCancel});
  final TextEditingController controller;
  final VoidCallback onCancel;

  static const _accent = Color(0xFF1F8046);
  static const _hintMuted = Color(0xFF4C4C4C);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCancel,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Text(
                'search_cancel'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppInputField(
              controller: controller,
              hintText: 'search_hint'.tr(),
              autofocus: true,
              leading: SvgPicture.asset(
                'assets/images/home/search.svg',
                width: 20,
                height: 20,
              ),
              trailing: controller.text.isEmpty
                  ? null
                  : GestureDetector(
                      onTap: controller.clear,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: _hintMuted,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
