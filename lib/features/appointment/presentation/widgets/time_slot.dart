import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import 'booking_tokens.dart';

enum TimeSlotState { defaultState, selected, booked }

/// Time slot button for the booking Date&Time screen (Figma `276:4187`).
class TimeSlot extends StatelessWidget {
  const TimeSlot({
    super.key,
    required this.time,
    required this.state,
    this.onTap,
  });

  final String time;
  final TimeSlotState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = state == TimeSlotState.selected;
    final isBooked = state == TimeSlotState.booked;

    if (isSelected) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 40,
          padding: const EdgeInsetsDirectional.only(start: 12, end: 20),
          decoration: BoxDecoration(
            color: BookingTokens.secondarySelect,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 20, color: Colors.white),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bg = isBooked ? BookingTokens.bgNeutral50 : BookingTokens.bgNeutral25;
    final color =
        isBooked ? BookingTokens.textDisabled : BookingTokens.textPrimary;

    return InkWell(
      onTap: isBooked ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: isBooked
              ? null
              : Border.all(color: BookingTokens.borderNeutral),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (isBooked)
              Text(
                'booking_slot_booked'.tr(),
                style: const TextStyle(
                  fontSize: 11,
                  color: BookingTokens.textDisabled,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
