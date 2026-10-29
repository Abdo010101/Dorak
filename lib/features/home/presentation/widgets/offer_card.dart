import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.title,
    required this.centerName,
    required this.price,
    required this.imageAsset,
  });

  final String title;
  final String centerName;
  final String price;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1D1D1D),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 171 / 116,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  centerName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4C4C4C),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBFEE3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/sar.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F8046),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: Text(
                    'offer_book_cta'.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF175CD3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
