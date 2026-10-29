import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart'
    show AppTypography;
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/booking_card.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/cancel_booking_sheet.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Phase 11 — Account 04 Booking details (Figma `208:2535`), Account 04b
/// pending variant (`362:3487`). Reads the [AppointmentResponse] passed via
/// go_router `extra`. Shows status badge, booking number, center summary,
/// appointment rows (date/time/doctor/service/fees), map preview, primary CTA
/// and cancel link. RTL-first via directional alignment.
class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({super.key, this.appointment});

  final AppointmentResponse? appointment;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final a = appointment;
    final isPending = (a?.status ?? 'confirmed') == 'pending';
    final status = isPending ? BookingStatus.pending : BookingStatus.confirmed;

    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(title: 'booking_details_title'.tr()),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                children: [
                  _StatusRow(status: status, bookingNumber: _bookingNumber(a)),
                  const SizedBox(height: 16),
                  AppBookingSummaryHeader(
                    title: a?.name ?? '',
                    subtitle: a?.phone ?? '',
                    imageAsset: 'assets/images/home/center1.png',
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    rows: [
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'booking_details_date'.tr(),
                        value: _dateText(a),
                      ),
                      _InfoRow(
                        icon: Icons.access_time,
                        label: 'booking_details_time'.tr(),
                        value: a?.date ?? '—',
                      ),
                      _InfoRow(
                        icon: Icons.person_outline,
                        label: 'booking_details_doctor'.tr(),
                        value: a?.name ?? '—',
                      ),
                      _InfoRow(
                        icon: Icons.medical_services_outlined,
                        label: 'booking_details_service'.tr(),
                        value: a?.mainSpecialization ?? '—',
                      ),
                      _InfoRow(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'booking_details_fees'.tr(),
                        value: a?.rate != null && a!.rate!.isNotEmpty
                            ? '${a.rate} ${'currency_sar'.tr()}'
                            : '—',
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppMapPreview(
                    pinLabel: 'booking_details_directions'.tr(),
                    openMapLabel: 'booking_details_open_map'.tr(),
                  ),
                ],
              ),
            ),
            _ActionBar(
              status: status,
              onReschedule: () {
                // TODO(wire): navigate to reschedule flow when the BRD lands.
              },
              onCancel: () => _openCancelSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  String _bookingNumber(AppointmentResponse? a) {
    final id = a?.id;
    if (id == null) return '—';
    return 'DR-${id.toString().padLeft(5, '0')}';
  }

  String _dateText(AppointmentResponse? a) {
    final parts = [a?.day, a?.date, a?.month]
        .where((s) => s != null && s.isNotEmpty)
        .toList();
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  Future<void> _openCancelSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CancelBookingSheet(appointment: appointment),
    );
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
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 12),
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
    required this.status,
    required this.onReschedule,
    required this.onCancel,
  });

  final BookingStatus status;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final canCancel = status == BookingStatus.confirmed ||
        status == BookingStatus.pending;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
        child: Column(
          children: [
            AppPrimaryButton(
              label: status == BookingStatus.pending
                  ? 'booking_details_track'.tr()
                  : 'booking_details_reschedule'.tr(),
              onPressed: onReschedule,
            ),
            if (canCancel) ...[
              const SizedBox(height: 10),
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
