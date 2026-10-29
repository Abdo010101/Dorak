import 'package:flutter/material.dart';

import 'booking_tokens.dart';

/// Clinic row used by the booking Date&Time header and the Review clinic card.
/// Figma: `438:13223` and `438:12767`. Written in logical order (text start,
/// image end) so Flutter mirrors in RTL.
class BookingSummaryHeader extends StatelessWidget {
  const BookingSummaryHeader({
    super.key,
    required this.name,
    required this.subtitle,
    this.imageAsset,
    this.backgroundColor,
    this.border,
    this.imageSize = const Size(81, 62),
    this.padding = const EdgeInsetsDirectional.only(start: 14, end: 8),
  });

  final String name;
  final String subtitle;
  final String? imageAsset;
  final Color? backgroundColor;
  final Border? border;
  final Size imageSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor ?? BookingTokens.bgNeutral25,
        borderRadius: BorderRadius.circular(12),
        border: border ?? Border.all(color: BookingTokens.borderNeutral),
      ),
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: BookingTokens.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BookingTokens.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ClinicImage(asset: imageAsset, size: imageSize),
        ],
      ),
    );
  }
}

class _ClinicImage extends StatelessWidget {
  const _ClinicImage({required this.asset, required this.size});

  final String? asset;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: asset != null
          ? Image.asset(
              asset!,
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(size),
            )
          : _placeholder(size),
    );
  }

  Widget _placeholder(Size size) => Container(
        width: size.width,
        height: size.height,
        color: BookingTokens.bgNeutral50,
        alignment: Alignment.center,
        child: const Icon(
          Icons.local_hospital_outlined,
          size: 24,
          color: BookingTokens.textDisabled,
        ),
      );
}
