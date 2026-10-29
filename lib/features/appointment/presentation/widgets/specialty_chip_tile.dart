import 'package:flutter/material.dart';

import 'booking_tokens.dart';

/// Specialty tile used in the booking Screen 1 picker.
/// Figma `jA3JQXye9DbBrxzNkEj9nf` nodes `177:945` / `177:954` (171.5×80).
///
/// States: available (default), selected.
class SpecialtyChipTile extends StatelessWidget {
  const SpecialtyChipTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? BookingTokens.accentBg25 : Colors.white;
    final border = selected
        ? BookingTokens.accent
        : BookingTokens.borderNeutral;
    final iconBg = selected
        ? BookingTokens.accent
        : BookingTokens.bgNeutral50;
    final iconColor = selected ? Colors.white : BookingTokens.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? BookingTokens.accent
                      : BookingTokens.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
