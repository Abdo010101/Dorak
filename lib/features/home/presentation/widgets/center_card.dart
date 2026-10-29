import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CenterCard extends StatelessWidget {
  const CenterCard({
    super.key,
    required this.name,
    required this.specialties,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.imageAsset,
  });

  final String name;
  final String specialties;
  final String location;
  final String rating;
  final String reviewCount;
  final String distance;
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
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 175 / 96,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(imageAsset, fit: BoxFit.cover),
                ),
              ),
              PositionedDirectional(
                top: 8,
                start: 8,
                child: _RatingChip(rating: rating, count: reviewCount),
              ),
              PositionedDirectional(
                top: 8,
                end: 8,
                child: _DistanceTag(value: distance),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EFFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    specialties,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF001A6D),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4C4C4C),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/home/call.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'تفاصيل المركز',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF175CD3),
                      ),
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

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating, required this.count});
  final String rating;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4C4C4C)),
          ),
          const SizedBox(width: 4),
          Text(
            rating,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/images/home/star.svg',
            width: 16,
            height: 16,
          ),
        ],
      ),
    );
  }
}

class _DistanceTag extends StatelessWidget {
  const _DistanceTag({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F8046),
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/images/home/location.svg',
            width: 14,
            height: 14,
          ),
        ],
      ),
    );
  }
}
