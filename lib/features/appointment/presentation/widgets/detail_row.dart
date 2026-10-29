import 'package:flutter/material.dart';

import 'booking_tokens.dart';

/// Icon + label + value row used by the appointment-details, patient-and-payment,
/// and confirmed-summary cards. Written in logical order; mirrors in RTL.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: BookingTokens.borderNeutral),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: BookingTokens.textPrimary),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: BookingTokens.textSecondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? BookingTokens.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
