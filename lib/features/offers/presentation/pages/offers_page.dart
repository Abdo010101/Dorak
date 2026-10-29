import 'package:dorakpattient/features/home/presentation/widgets/offer_card.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Phase 8 — Offers list. No dedicated Figma frame; pattern-matched from
/// legacy `OffersScreen` and composed from the Phase 8 home `OfferCard`.
class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  static const _textPrimary = Color(0xFF1D1D1D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Text(
                'offers'.tr(),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                childAspectRatio: 0.70,
                children: const [
                  OfferCard(
                    centerId: 2,
                    title: 'فحص البشرة',
                    centerName: 'مجمع النور الطبي',
                    price: '١٤٩',
                    imageAsset: 'assets/images/home/skin_offer.png',
                  ),
                  OfferCard(
                    centerId: 1,
                    title: 'تنظيف الأسنان',
                    centerName: 'مركز العناية الطبي',
                    price: '١٩٩',
                    imageAsset: 'assets/images/home/dental_offer.png',
                  ),
                  OfferCard(
                    centerId: 2,
                    title: 'فحص البشرة',
                    centerName: 'مجمع النور الطبي',
                    price: '١٤٩',
                    imageAsset: 'assets/images/home/skin_offer.png',
                  ),
                  OfferCard(
                    centerId: 1,
                    title: 'تنظيف الأسنان',
                    centerName: 'مركز العناية الطبي',
                    price: '١٩٩',
                    imageAsset: 'assets/images/home/dental_offer.png',
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
