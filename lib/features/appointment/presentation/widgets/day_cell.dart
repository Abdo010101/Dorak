import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import 'booking_tokens.dart';

enum DayCellState { available, selected, closed }

/// Day picker cell for the booking Date&Time screen (Figma `276:4153`).
class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.date,
    required this.state,
    this.onTap,
  });

  final String day;
  final String date;
  final DayCellState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = state == DayCellState.selected;
    final isClosed = state == DayCellState.closed;

    final bg = isSelected
        ? BookingTokens.accent
        : isClosed
            ? BookingTokens.bgNeutral50
            : BookingTokens.bgNeutral25;
    final labelColor = isSelected
        ? Colors.white
        : isClosed
            ? BookingTokens.textDisabled
            : BookingTokens.textPrimary;

    return InkWell(
      onTap: isClosed ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: isSelected || isClosed
              ? null
              : Border.all(color: BookingTokens.borderNeutral),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 4),
            if (isSelected)
              const Icon(Icons.check_circle_outline,
                  size: 18, color: Colors.white)
            else if (isClosed)
              Text(
                'booking_day_closed'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  color: BookingTokens.textDisabled,
                ),
              )
            else
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: BookingTokens.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
