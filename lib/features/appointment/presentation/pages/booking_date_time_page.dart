import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../widgets/booking_stepper.dart';
import '../widgets/booking_summary_header.dart';
import '../widgets/booking_tokens.dart';
import '../widgets/day_cell.dart';
import '../widgets/time_slot.dart';

/// UI-redesign booking flow — step 2: pick date & time.
///
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `438:12682`. Static mock; selection
/// state is local until `BookingCubit` wiring lands.
class BookingDateTimePage extends StatefulWidget {
  const BookingDateTimePage({super.key});

  @override
  State<BookingDateTimePage> createState() => _BookingDateTimePageState();
}

class _BookingDateTimePageState extends State<BookingDateTimePage> {
  static const _days = <_DayItem>[
    _DayItem(day: 'الاثنين', date: '٢٦', state: DayCellState.available),
    _DayItem(day: 'الأحد', date: '٢٥', state: DayCellState.available),
    _DayItem(day: 'السبت', date: '٢٤', state: DayCellState.available),
    _DayItem(day: 'الجمعة', date: '٢٣', state: DayCellState.closed),
    _DayItem(day: 'الخميس', date: '٢٢', state: DayCellState.available),
  ];

  static const _amSlots = <_SlotItem>[
    _SlotItem(time: '١٠:٠٠ ص', state: TimeSlotState.booked),
    _SlotItem(time: '٩:٣٠ ص', state: TimeSlotState.defaultState),
    _SlotItem(time: '٩:٠٠ ص', state: TimeSlotState.defaultState),
    _SlotItem(time: '١١:٣٠ ص', state: TimeSlotState.defaultState),
    _SlotItem(time: '١١:٠٠ ص', state: TimeSlotState.defaultState),
    _SlotItem(time: '١٠:٣٠ ص', state: TimeSlotState.defaultState),
  ];

  static const _pmSlots = <_SlotItem>[
    _SlotItem(time: '٥:٠٠ م', state: TimeSlotState.defaultState),
    _SlotItem(time: '٤:٣٠ م', state: TimeSlotState.defaultState),
    _SlotItem(time: '٤:٠٠ م', state: TimeSlotState.defaultState),
  ];

  int _selectedDayIndex = 4; // Thursday ٢٢ pre-selected per Figma.
  String? _selectedTime = '٤:٣٠ م';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: 'booking_select_title'.tr(),
              onBack: () => context.canPop() ? context.pop() : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
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
                  _MonthRow(),
                  const SizedBox(height: 16),
                  _DaysStrip(
                    days: _days,
                    selectedIndex: _selectedDayIndex,
                    onTap: (i) => setState(() => _selectedDayIndex = i),
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
                  _SlotGroup(
                    icon: Icons.wb_sunny_outlined,
                    label: 'booking_slot_am'.tr(),
                    slots: _amSlots,
                    selectedTime: _selectedTime,
                    onSelect: (t) => setState(() => _selectedTime = t),
                  ),
                  const SizedBox(height: 16),
                  _SlotGroup(
                    icon: Icons.nightlight_outlined,
                    label: 'booking_slot_pm'.tr(),
                    slots: _pmSlots,
                    selectedTime: _selectedTime,
                    onSelect: (t) => setState(() => _selectedTime = t),
                  ),
                  const SizedBox(height: 16),
                  _SelectedSummary(
                    date: 'الخميس، ٢٢ أكتوبر ٢٠٢٦',
                    time:
                        _selectedTime == null ? '' : '${_selectedTime!} مساءً',
                    doctorCenter: 'د. أحمد العلي · مجمع النور الطبي',
                  ),
                ],
              ),
            ),
            _BottomBar(
              onNext: _selectedTime == null
                  ? null
                  : () => context.pushNamed(RouteNames.bookingReview),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayItem {
  const _DayItem({
    required this.day,
    required this.date,
    required this.state,
  });
  final String day;
  final String date;
  final DayCellState state;
}

class _SlotItem {
  const _SlotItem({required this.time, required this.state});
  final String time;
  final TimeSlotState state;
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

class _MonthRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'أكتوبر ٢٠٢٦',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: BookingTokens.textPrimary,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.calendar_month_outlined,
            size: 20,
            color: BookingTokens.infoText,
          ),
          label: Text(
            'booking_open_calendar'.tr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: BookingTokens.infoText,
            ),
          ),
        ),
      ],
    );
  }
}

class _DaysStrip extends StatelessWidget {
  const _DaysStrip({
    required this.days,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<_DayItem> days;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < days.length; i++) ...[
          Expanded(
            child: DayCell(
              day: days[i].day,
              date: days[i].date,
              state: i == selectedIndex ? DayCellState.selected : days[i].state,
              onTap: () => onTap(i),
            ),
          ),
          if (i != days.length - 1) const SizedBox(width: 6),
        ],
      ],
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
  final List<_SlotItem> slots;
  final String? selectedTime;
  final ValueChanged<String> onSelect;

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

  final List<_SlotItem> slots;
  final String? selectedTime;
  final ValueChanged<String> onSelect;

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
                    time: rowSlots[j].time,
                    state: rowSlots[j].state == TimeSlotState.booked
                        ? TimeSlotState.booked
                        : (selectedTime == rowSlots[j].time
                            ? TimeSlotState.selected
                            : TimeSlotState.defaultState),
                    onTap: () => onSelect(rowSlots[j].time),
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
  const _SelectedSummary({
    required this.date,
    required this.time,
    required this.doctorCenter,
  });
  final String date;
  final String time;
  final String doctorCenter;

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
          const SizedBox(height: 8),
          _SummaryLine(icon: Icons.person_outline, text: doctorCenter),
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
