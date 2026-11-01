import 'package:flutter/material.dart';

class SpecialtyChipData {
  const SpecialtyChipData(this.label, this.selected);
  final String label;
  final bool selected;
}

class SpecialtyChipRow extends StatelessWidget {
  const SpecialtyChipRow({super.key, required this.chips, this.onTap});
  final List<SpecialtyChipData> chips;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: Directionality.of(context) == TextDirection.ltr,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = chips[i];
          final bg =
              c.selected ? const Color(0xFF1F8046) : const Color(0xFFFAFAFA);
          final fg = c.selected ? Colors.white : const Color(0xFF1D1D1D);
          return InkWell(
            onTap: onTap == null ? null : () => onTap!(i),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: c.selected
                    ? null
                    : Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Text(
                c.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: c.selected ? FontWeight.w700 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
