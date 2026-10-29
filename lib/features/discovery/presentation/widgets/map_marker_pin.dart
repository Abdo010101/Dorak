import 'package:flutter/material.dart';

/// Figma `203:2005` / `203:2011` / `455:4340` — map marker pill.
/// Selected = green background + white text. Default = white bg + dark text.
class MapMarkerPin extends StatelessWidget {
  const MapMarkerPin({
    super.key,
    required this.label,
    required this.rating,
    required this.selected,
    this.onTap,
  });

  final String label;
  final String rating;
  final bool selected;
  final VoidCallback? onTap;

  static const _accent = Color(0xFF1F8046);

  @override
  Widget build(BuildContext context) {
    final bg = selected ? _accent : Colors.white;
    final fg = selected ? Colors.white : const Color(0xFF1D1D1D);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 28,
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label $rating',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.local_hospital_outlined,
              size: 16,
              color: fg,
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma `203:2023` — blue "you are here" dot.
class UserLocationDot extends StatelessWidget {
  const UserLocationDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
