import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart'
    show AppTypography;
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/data/repository/appointment_repo.dart';
import 'package:dorakpattient/features/appointment/logic/booking_details_cubit.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/booking_card.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/cancel_booking_sheet.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/reschedule_sheet.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Phase 11 — Account 04 Booking details (Figma `208:2535`), Account 04b
/// pending variant (`362:3487`).
///
/// Hydrates from the [AppointmentResponse] passed via router `extra`, then
/// fetches the live reservation via `GET /patient/reservations/{id}` so
/// status / can_cancel / can_reschedule / change_deadline reflect what the
/// backend thinks right now (scope answer §8.7).
class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, this.appointment});

  final AppointmentResponse? appointment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingDetailsCubit>(
      create: (_) {
        final cubit = BookingDetailsCubit(
          repo: locator<AppointmentsRepository>(),
        )..seedFrom(appointment);
        final id = appointment?.id;
        if (id != null) cubit.load(id);
        return cubit;
      },
      child: _View(initial: appointment),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.initial});
  final AppointmentResponse? initial;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(title: 'booking_details_title'.tr()),
      body: SafeArea(
        top: false,
        child: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
          builder: (context, s) {
            final a = s.reservation ?? initial;
            if (a == null && s.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (a == null) {
              return Center(
                child: Text(
                  s.errorMessage ?? 'something_went_wrong'.tr(),
                  style: TextStyle(color: colors.textSecondary),
                ),
              );
            }
            return Column(
              children: [
                Expanded(child: _Body(a: a)),
                _ActionBar(
                  reservation: a,
                  onReschedule: () => _openReschedule(context, a),
                  onCancel: () => _openCancelSheet(context, a),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openReschedule(
    BuildContext context,
    AppointmentResponse a,
  ) async {
    final updated = await showRescheduleSheet(context, reservation: a);
    if (updated != null && context.mounted) {
      context.read<BookingDetailsCubit>().applyUpdated(updated);
    }
  }

  Future<void> _openCancelSheet(
    BuildContext context,
    AppointmentResponse a,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CancelBookingSheet(appointment: a),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.a});
  final AppointmentResponse a;

  @override
  Widget build(BuildContext context) {
    final status = _statusEnum(a);
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
      children: [
        _StatusRow(status: status, bookingNumber: a.bookingNumber ?? '—'),
        const SizedBox(height: 16),
        AppBookingSummaryHeader(
          title: a.place?.name ?? '',
          subtitle: a.place?.branch ?? a.place?.address ?? '',
          imageAsset: 'assets/images/home/center1.png',
        ),
        const SizedBox(height: 16),
        _InfoCard(rows: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'booking_details_date'.tr(),
            value: a.dateLabel ?? '—',
          ),
          _InfoRow(
            icon: Icons.access_time,
            label: 'booking_details_time'.tr(),
            value: a.timeLabel ?? '—',
          ),
          _InfoRow(
            icon: Icons.medical_services_outlined,
            label: 'booking_details_service'.tr(),
            value: a.service ?? a.specialization?.name ?? '—',
          ),
          _InfoRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'booking_label_payment'.tr(),
            value:
                a.paymentMethod ?? 'booking_payment_in_center'.tr(),
            isLast: true,
          ),
        ]),
        if ((a.place?.lat ?? 0) != 0 && (a.place?.lng ?? 0) != 0) ...[
          const SizedBox(height: 16),
          AppMapPreview(
            pinLabel: a.place?.address ?? 'booking_details_directions'.tr(),
            openMapLabel: 'booking_details_open_map'.tr(),
          ),
        ],
        if (a.cancellation?.label != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              a.cancellation!.label!,
              style: const TextStyle(color: Color(0xFFB42318)),
            ),
          ),
        ],
      ],
    );
  }

  BookingStatus _statusEnum(AppointmentResponse a) {
    switch (a.status) {
      case 'pending':
        return BookingStatus.pending;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'no_show':
        return BookingStatus.cancelled;
      case 'confirmed':
      default:
        return BookingStatus.confirmed;
    }
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.status, required this.bookingNumber});
  final BookingStatus status;
  final String bookingNumber;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final (bg, fg, label) = switch (status) {
      BookingStatus.confirmed => (
          const Color(0xFFDBFEE3),
          const Color(0xFF1F8046),
          'booking_status_confirmed'
        ),
      BookingStatus.pending => (
          const Color(0xFFFFFAEB),
          const Color(0xFFB54708),
          'booking_status_pending'
        ),
      BookingStatus.completed => (
          const Color(0xFFE5EFFF),
          const Color(0xFF175CD3),
          'booking_status_completed'
        ),
      BookingStatus.cancelled => (
          const Color(0xFFFEE4E2),
          const Color(0xFFB42318),
          'booking_status_cancelled'
        ),
    };
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Text(
            label.tr(),
            style: typo.textMdSemibold.copyWith(color: fg),
          ),
        ),
        const Spacer(),
        Text(
          bookingNumber,
          style: typo.textLgSemibold.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(width: 6),
        Text(
          'booking_details_number_label'.tr(),
          style: typo.textLgRegular.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: rows),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Container(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.fieldBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: typo.textLgRegular.copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: typo.textLgRegular.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(width: 10),
          Icon(icon, size: 20, color: colors.textSecondary),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.reservation,
    required this.onReschedule,
    required this.onCancel,
  });

  final AppointmentResponse reservation;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final canReschedule = reservation.canReschedule ?? false;
    final canCancel = reservation.canCancel ?? false;
    final isPending = reservation.status == 'pending';
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
        child: Column(
          children: [
            if (canReschedule)
              AppPrimaryButton(
                label: isPending
                    ? 'booking_details_track'.tr()
                    : 'booking_details_reschedule'.tr(),
                onPressed: onReschedule,
              ),
            if (canCancel) ...[
              if (canReschedule) const SizedBox(height: 10),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'booking_details_cancel_link'.tr(),
                  style: typo.textLgSemibold.copyWith(
                    color: colors.textPrimary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
