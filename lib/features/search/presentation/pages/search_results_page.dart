import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/specialty_chip_row.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Discovery 03 Search results (Figma node `203:1690`).
///
/// Static mock data. SearchBloc wiring lands with the Phase 5
/// SearchController/SearchResultController/FilterController migration.
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
  void dispose() {
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
            _TopBar(controller: _query, onCancel: () => context.pop()),
            Expanded(
              child: ListView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '4 ${'search_results_label'.tr()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: _textSecondary,
                        ),
                      ),
                      Text(
                        'search_medical_centers'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
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
                ],
              ),
            ),
          ],
        ),
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
