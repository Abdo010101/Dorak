import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/specialty_chip_row.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Discovery 03 Search results (Figma node `203:1690`) and 03b
/// Search no-results (Figma node `352:3400`).
///
/// Static mock data. SearchBloc wiring lands with the Phase 5
/// SearchController/SearchResultController/FilterController migration.
/// Empty-state is triggered when the query contains `xxx` as a static
/// sentinel until the cubit wiring lands.
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
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  bool get _showEmpty =>
      _query.text.trim().isNotEmpty && _query.text.contains('xxx');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(controller: _query, onCancel: () => context.pop()),
            Expanded(
              child: _showEmpty ? _buildEmpty() : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
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
        const SpecialtyChipRow(
          chips: [
            SpecialtyChipData('طب الأسنان', true),
            SpecialtyChipData('تقويم الأسنان', false),
          ],
        ),
        const SizedBox(height: 16),
        _listHeader(count: 4, title: 'search_medical_centers'.tr()),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: CenterCard(
                name: 'مركز العناية الطبي',
                specialties: 'الأسنان ، الجلدية',
                location: 'الدمام · حي الشاطئ',
                rating: '٤٫٨',
                reviewCount: '(١٢٠)',
                distance: '١٫٢ كم',
                imageAsset: 'assets/images/home/center1.png',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: CenterCard(
                name: 'مجمع النور الطبي',
                specialties: 'الأسنان ، الأطفال',
                location: 'الدمام · حي الفيصلية',
                rating: '٤٫٦',
                reviewCount: '(١٢٠)',
                distance: '٣٫٤ كم',
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
                name: 'مركز الحياة الطبي',
                specialties: 'العيون ، الجلدية',
                location: 'الدمام · حي المزروعية',
                rating: '٤٫٥',
                reviewCount: '(١٢٠)',
                distance: '٣٫١ كم',
                imageAsset: 'assets/images/home/center1.png',
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: CenterCard(
                name: 'مركز الحياة الطبي',
                specialties: 'العيون ، الجلدية',
                location: 'الدمام · حي المزروعية',
                rating: '٤٫٥',
                reviewCount: '(١٢٠)',
                distance: '٣٫١ كم',
                imageAsset: 'assets/images/home/center2.png',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _listHeader(count: 2, title: 'search_clinics'.tr()),
        const SizedBox(height: 12),
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
      ],
    );
  }

  Widget _listHeader({required int count, required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count ${'search_results_label'.tr()}',
          style: const TextStyle(fontSize: 14, color: _textSecondary),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
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
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'search_empty_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1F8046),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _query.clear(),
              child: Text(
                'search_empty_cta'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onCancel,
            child: Text(
              'search_cancel'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsetsDirectional.only(start: 14, end: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _accent, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/home/search.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
