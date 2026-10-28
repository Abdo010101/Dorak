import 'package:dorakpattient/features/home/presentation/widgets/center_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/home_header.dart';
import 'package:dorakpattient/features/home/presentation/widgets/location_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/offer_card.dart';
import 'package:dorakpattient/features/home/presentation/widgets/section_header.dart';
import 'package:dorakpattient/features/home/presentation/widgets/specialty_chip_row.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Phase 8 — Home — الرئيسية (Figma node `171:509`).
///
/// Static mock data for now; wiring to `HomeCubit` lands with the
/// `HomeController` migration in a Phase 5 sub-phase.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HomeHeader(greeting: 'أهلا فيك', subtitle: 'موعدك المناسب بانتظارك'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const LocationCard(
                    label: 'موقعك الحالي',
                    value: 'الدمام، حي الفيصلية',
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
                          title: 'فحص البشرة',
                          centerName: 'مجمع النور الطبي',
                          price: '١٤٩',
                          imageAsset: 'assets/images/home/skin_offer.png',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: OfferCard(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

