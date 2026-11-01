import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/state/status.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../../../data/models/response/booking_response.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';
import '../widgets/booking_stepper.dart';
import '../widgets/booking_summary_header.dart';
import '../widgets/booking_tokens.dart';
import '../widgets/day_cell.dart';
import '../widgets/time_slot.dart';

/// UI-redesign booking flow — step 2: pick date & time.
///
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `438:12682`. Wired to [BookingCubit]:
/// day strip reads `state.days`, slots read `state.morningSlots` +
/// `state.eveningSlots`. The parent route must have called
/// `BookingCubit.start(...)` on step 1 so doctorId / medicalCenterId /
/// variant are populated.
class BookingDateTimePage extends StatefulWidget {
  const BookingDateTimePage({super.key});

  @override
  State<BookingDateTimePage> createState() => _BookingDateTimePageState();
}

class _BookingDateTimePageState extends State<BookingDateTimePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookingCubit>().loadDays();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, s) {
            final cubit = context.read<BookingCubit>();
            return Column(
              children: [
                _TopBar(
                  title: 'booking_select_title'.tr(),
                  onBack: () => context.canPop() ? context.pop() : null,
                ),
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                    children: [
                      const BookingSummaryHeader(
                        name: 'عيادة دكتور احمد',
                        subtitle: 'طب الأسنان',
                      ),
                      const SizedBox(height: 16),
                      const BookingStepper(current: BookingStep.dateTime),
                      const SizedBox(height: 16),
                      _SectionLabel('booking_step_pick_day'.tr()),
                      const SizedBox(height: 16),
                      _DaysSection(
                        status: s.daysStatus,
                        days: s.days,
                        selectedDate: s.selectedDay?.date,
                        onTap: cubit.selectDay,
                      ),
                      const SizedBox(height: 16),
                      const _Legend(),
                      const SizedBox(height: 24),
                      _SectionLabel('booking_step_pick_time'.tr()),
                      const SizedBox(height: 6),
                      Text(
                        'booking_times_hint'.tr(),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          color: BookingTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SlotsSection(
                        status: s.slotsStatus,
                        morning: s.morningSlots,
                        evening: s.eveningSlots,
                        selectedTime: s.selectedSlot?.time,
                        onSelect: cubit.selectSlot,
                      ),
                      if (s.selectedDay != null && s.selectedSlot != null) ...[
                        const SizedBox(height: 16),
                        _SelectedSummary(
                          date: s.selectedDay!.dateLabel ??
                              s.selectedDay!.date ??
                              '',
                          time: s.selectedSlot!.label ??
                              s.selectedSlot!.time ??
                              '',
                        ),
                      ],
                      if (s.errorMessage != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          s.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFB42318),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _BottomBar(
                  onNext: s.canPreview
                      ? () => context.pushNamed(RouteNames.bookingReview)
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BookingTokens.textPrimary,
              ),
            ),
          ),
          PositionedDirectional(
            start: 4,
            top: 4,
            child: AppBackButton(onPressed: onBack),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: BookingTokens.textPrimary,
        ),
      ),
    );
  }
}

class _DaysSection extends StatelessWidget {
  const _DaysSection({
    required this.status,
    required this.days,
    required this.selectedDate,
    required this.onTap,
  });

  final Status status;
  final List<BookingDay> days;
  final String? selectedDate;
  final ValueChanged<BookingDay> onTap;

  @override
  Widget build(BuildContext context) {
    if (status == Status.loading && days.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (days.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'booking_days_empty'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: BookingTokens.textSecondary),
        ),
      );
    }
    // Horizontal strip (RTL-safe via reverse).
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final d = days[i];
          final isSelected = d.date == selectedDate;
          return SizedBox(
            width: 64,
            child: DayCell(
              day: d.dayLabel ?? '',
              date: d.dateLabel ?? d.date ?? '',
              state: isSelected
                  ? DayCellState.selected
                  : (d.isAvailable
                      ? DayCellState.available
                      : DayCellState.closed),
              onTap: d.isAvailable ? () => onTap(d) : null,
            ),
          );
        },
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendDot(
          color: BookingTokens.accent,
          label: 'booking_legend_available'.tr(),
        ),
        const SizedBox(width: 16),
        _LegendDot(
          color: BookingTokens.textDisabled,
          label: 'booking_legend_unavailable'.tr(),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: BookingTokens.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SlotsSection extends StatelessWidget {
  const _SlotsSection({
    required this.status,
    required this.morning,
    required this.evening,
    required this.selectedTime,
    required this.onSelect,
  });

  final Status status;
  final List<BookingSlot> morning;
  final List<BookingSlot> evening;
  final String? selectedTime;
  final ValueChanged<BookingSlot> onSelect;

  @override
  Widget build(BuildContext context) {
    if (status == Status.loading && morning.isEmpty && evening.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (morning.isEmpty && evening.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'booking_slots_empty'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: BookingTokens.textSecondary),
        ),
      );
    }
    return Column(
      children: [
        if (morning.isNotEmpty)
          _SlotGroup(
            icon: Icons.wb_sunny_outlined,
            label: 'booking_slot_am'.tr(),
            slots: morning,
            selectedTime: selectedTime,
            onSelect: onSelect,
          ),
        if (morning.isNotEmpty && evening.isNotEmpty)
          const SizedBox(height: 16),
        if (evening.isNotEmpty)
          _SlotGroup(
            icon: Icons.nightlight_outlined,
            label: 'booking_slot_pm'.tr(),
            slots: evening,
            selectedTime: selectedTime,
            onSelect: onSelect,
          ),
      ],
    );
  }
}

class _SlotGroup extends StatelessWidget {
  const _SlotGroup({
    required this.icon,
    required this.label,
    required this.slots,
    required this.selectedTime,
    required this.onSelect,
  });

  final IconData icon;
  final String label;
  final List<BookingSlot> slots;
  final String? selectedTime;
  final ValueChanged<BookingSlot> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BookingTokens.bgNeutral25,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: BookingTokens.textPrimary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: BookingTokens.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _SlotGrid(
            slots: slots,
            selectedTime: selectedTime,
            onSelect: onSelect,
          ),
        ],
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.selectedTime,
    required this.onSelect,
  });

  final List<BookingSlot> slots;
  final String? selectedTime;
  final ValueChanged<BookingSlot> onSelect;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < slots.length; i += 3) {
      final rowSlots = slots.sublist(i, (i + 3).clamp(0, slots.length));
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 6),
          child: Row(
            children: [
              for (int j = 0; j < rowSlots.length; j++) ...[
                Expanded(
                  child: TimeSlot(
                    time: rowSlots[j].label ?? rowSlots[j].time ?? '',
                    state: (rowSlots[j].available ?? true)
                        ? (selectedTime == rowSlots[j].time
                            ? TimeSlotState.selected
                            : TimeSlotState.defaultState)
                        : TimeSlotState.booked,
                    onTap: (rowSlots[j].available ?? true)
                        ? () => onSelect(rowSlots[j])
                        : null,
                  ),
                ),
                if (j != rowSlots.length - 1) const SizedBox(width: 6),
              ],
              for (int k = rowSlots.length; k < 3; k++) ...[
                const Expanded(child: SizedBox()),
                if (k != 2) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _SelectedSummary extends StatelessWidget {
  const _SelectedSummary({required this.date, required this.time});
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BookingTokens.successRowBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'booking_selected_title'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: BookingTokens.accent,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryLine(icon: Icons.calendar_today_outlined, text: date),
          const SizedBox(height: 8),
          _SummaryLine(icon: Icons.access_time, text: time),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: BookingTokens.textPrimary),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: BookingTokens.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onNext});
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0D1D1D1D),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 8),
        child: Column(
          children: [
            AppPrimaryButton(
              label: 'booking_next_cta'.tr(),
              onPressed: onNext,
              trailingIcon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_forward
                    : Icons.arrow_back,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'booking_not_confirmed_hint'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: BookingTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
