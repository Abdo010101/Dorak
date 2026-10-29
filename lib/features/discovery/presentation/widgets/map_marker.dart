import 'package:flutter/material.dart';

/// Figma `203:2005` family — green rounded badge: name + rating + shield icon.
class MapMarker extends StatelessWidget {
  const MapMarker({
    super.key,
    required this.label,
    required this.rating,
  });

  final String label;
  final String rating;

  static const _accent = Color(0xFF1F8046);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      padding: const EdgeInsetsDirectional.only(start: 10, end: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _accent, width: 1.5),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label $rating',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.local_hospital_outlined, size: 14, color: _accent),
        ],
      ),
    );
  }
}
