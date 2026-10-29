import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Figma `374:4452` — Explore header: logo + title + city picker.
class ExploreHeader extends StatelessWidget {
  const ExploreHeader({
    super.key,
    required this.title,
    required this.city,
    required this.onCityTap,
  });

  final String title;
  final String city;
  final VoidCallback onCityTap;

  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/home/dorak_mark.svg',
            width: 29,
            height: 34,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onCityTap,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/home/down.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(
                  'assets/images/home/location_icon.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
