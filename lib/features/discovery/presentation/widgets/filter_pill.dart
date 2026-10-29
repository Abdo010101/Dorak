import 'package:flutter/material.dart';

/// Figma `173:718` — one-pill filter row (settings icon · title · chevron).
class FilterPill extends StatelessWidget {
  const FilterPill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 36,
        padding: const EdgeInsetsDirectional.only(start: 12, end: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.tune,
              size: 20,
              color: Color(0xFF4C4C4C),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4C4C4C),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Color(0xFF4C4C4C),
            ),
          ],
        ),
      ),
    );
  }
}
