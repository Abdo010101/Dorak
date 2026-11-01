import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/data/models/response/booking_response.dart';
import 'package:dorakpattient/data/repository/appointment_repo.dart';
import 'package:dorakpattient/data/repository/booking_repo.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/appointment/logic/booking_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/booking_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Picks a new date + time via the same `/booking/days` + `/booking/slots`
/// endpoints the create-reservation flow uses, then posts
/// `POST /patient/reservations/{id}/reschedule {date, time}` (scope §10.2).
///
/// Returns the updated [AppointmentResponse] (same id, status back to
/// `pending`) so the caller can refresh its screen without a round-trip.
Future<AppointmentResponse?> showRescheduleSheet(
  BuildContext context, {
  required AppointmentResponse reservation,
}) {
  return showModalBottomSheet<AppointmentResponse>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) {
        // Build a sheet-local cubit so it does not stomp the booking stepper's
        // cubit if the user bounces between the two flows.
        final cubit = BookingCubit(
          bookingRepository: locator<BookingRepository>(),
        )..start(
            variant: reservation.place?.type == 'clinic'
                ? BookingVariant.clinic
                : BookingVariant.center,
            doctorId: reservation.place?.id ?? 0,
            medicalCenterId: reservation.place?.type == 'clinic'
                ? null
                : reservation.place?.id,
          );
        cubit.loadDays();
        return cubit;
      },
      child: _RescheduleBody(reservation: reservation),
    ),
  );
}

class _RescheduleBody extends StatefulWidget {
  const _RescheduleBody({required this.reservation});
  final AppointmentResponse reservation;

  @override
  State<_RescheduleBody> createState() => _RescheduleBodyState();
}

class _RescheduleBodyState extends State<_RescheduleBody> {
  bool _submitting = false;
  String? _errorMessage;

  Future<void> _submit(BookingState s) async {
    final id = widget.reservation.id;
    final date = s.selectedDay?.date;
    final time = s.selectedSlot?.time;
    if (id == null || date == null || time == null) return;
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final result = await locator<AppointmentsRepository>().reschedule(
      id,
      date: date,
      time: time,
    );
    if (!mounted) return;
    if (result.data == null) {
      setState(() {
        _submitting = false;
        _errorMessage = result.error?.message ?? 'something_went_wrong'.tr();
      });
      return;
    }
    Navigator.of(context).pop(result.data);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    const radii = Radius.circular(24);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.vertical(top: radii),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, s) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colors.fieldBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'reschedule_sheet_title'.tr(),
                  textAlign: TextAlign.center,
                  style: typo.titleMd.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 12),
                _DaysStrip(state: s),
                const SizedBox(height: 12),
                _SlotsBlock(state: s),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFB42318)),
                  ),
                ],
                const SizedBox(height: 20),
                AppPrimaryButton(
                  label: 'reschedule_confirm'.tr(),
                  isDisabled:
                      s.selectedDay == null || s.selectedSlot == null,
                  isLoading: _submitting,
                  onPressed: s.selectedDay == null || s.selectedSlot == null
                      ? null
                      : () => _submit(s),
                ),
                const SizedBox(height: 8),
                AppSecondaryButton(
                  label: 'cancel'.tr(),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DaysStrip extends StatelessWidget {
  const _DaysStrip({required this.state});
  final BookingState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    if (state.daysStatus == Status.loading && state.days.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.days.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'booking_days_empty'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (ctx, i) {
          final d = state.days[i];
          final selected = d.date == state.selectedDay?.date;
          return GestureDetector(
            onTap: d.isAvailable
                ? () => ctx.read<BookingCubit>().selectDay(d)
                : null,
            child: Container(
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colors.borderPrimary
                    : (d.isAvailable
                        ? colors.primaryTint
                        : const Color(0xFFF4F4F4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    d.dayLabel ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      color: selected ? Colors.white : colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    d.dateLabel ?? d.date ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SlotsBlock extends StatelessWidget {
  const _SlotsBlock({required this.state});
  final BookingState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    if (state.selectedDay == null) {
      return const SizedBox.shrink();
    }
    if (state.slotsStatus == Status.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final all = <BookingSlot>[...state.morningSlots, ...state.eveningSlots];
    if (all.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'booking_slots_empty'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in all)
          GestureDetector(
            onTap: (s.available ?? true)
                ? () => context.read<BookingCubit>().selectSlot(s)
                : null,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: s.time == state.selectedSlot?.time
                    ? colors.borderPrimary
                    : ((s.available ?? true)
                        ? colors.primaryTint
                        : const Color(0xFFF4F4F4)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                s.label ?? s.time ?? '',
                style: TextStyle(
                  color: s.time == state.selectedSlot?.time
                      ? Colors.white
                      : colors.textPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
