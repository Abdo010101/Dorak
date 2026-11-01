import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/data/models/response/general_response.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Phase 11 — Account 05 Cancel booking (Figma `208:2641`). Modal body only;
/// mount via `showModalBottomSheet` or [AppBottomSheet.show].
///
/// Reasons come from `general.cancellation_reasons` (scope §10.2). Each
/// reason has a stable `key` posted back to the backend and a localized
/// `label`. Mobile falls back to a baked-in 4-reason list if the general
/// response has not loaded yet.
class CancelBookingSheet extends StatefulWidget {
  const CancelBookingSheet({super.key, this.appointment});

  final AppointmentResponse? appointment;

  @override
  State<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<CancelBookingSheet> {
  CancellationReason? _reason;
  final _noteController = TextEditingController();

  static const List<CancellationReason> _fallbackReasons = [
    CancellationReason(key: 'schedule_conflict'),
    CancellationReason(key: 'booked_elsewhere'),
    CancellationReason(key: 'no_longer_needed'),
    CancellationReason(key: 'other'),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    const radii = Radius.circular(24);
    final reasons = context
            .select<GeneralCubit, List<CancellationReason>?>(
              (c) => c.state.generalResponse?.cancellationReasons,
            ) ??
        _fallbackReasons;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.vertical(top: radii),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
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
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.primaryTint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.error_outline,
                  size: 28,
                  color: colors.borderPrimary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'cancel_booking_title'.tr(),
              textAlign: TextAlign.center,
              style: typo.titleMd.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'cancel_booking_body'.tr(),
              textAlign: TextAlign.center,
              style: typo.textLgRegular.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            _ReasonGrid(
              reasons: reasons,
              selectedKey: _reason?.key,
              onTap: (r) => setState(() => _reason = r),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              minLines: 2,
              textAlignVertical: TextAlignVertical.top,
              style: typo.textMdRegular.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'cancel_booking_note_hint'.tr(),
                hintStyle:
                    typo.textMdRegular.copyWith(color: colors.textSecondary),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.fieldBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.borderPrimary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: 'cancel_booking_confirm'.tr(),
              isDisabled: _reason == null,
              onPressed: _reason == null ? null : _confirm,
            ),
            const SizedBox(height: 8),
            AppSecondaryButton(
              label: 'cancel_booking_keep'.tr(),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm() {
    final a = widget.appointment;
    final id = a?.id;
    if (id != null) {
      final cubit = context.read<AppointmentsCubit>();
      final idx = cubit.state.items.indexWhere((r) => r.id == id);
      if (idx >= 0) {
        cubit.cancel(
          idx,
          reasonKey: _reason?.key,
          note: _noteController.text,
        );
      }
    }
    Navigator.of(context).maybePop();
  }
}

class _ReasonGrid extends StatelessWidget {
  const _ReasonGrid({
    required this.reasons,
    required this.selectedKey,
    required this.onTap,
  });
  final List<CancellationReason> reasons;
  final String? selectedKey;
  final ValueChanged<CancellationReason> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < reasons.length; row += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                for (var col = 0; col < 2; col++)
                  if (row + col < reasons.length) ...[
                    Expanded(
                      child: _ReasonChip(
                        reason: reasons[row + col],
                        selected: selectedKey == reasons[row + col].key,
                        onTap: () => onTap(reasons[row + col]),
                      ),
                    ),
                    if (col == 0) const SizedBox(width: 8),
                  ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final CancellationReason reason;
  final bool selected;
  final VoidCallback onTap;

  static const Map<String, String> _fallbackLabels = {
    'schedule_conflict': 'cancel_reason_schedule_conflict',
    'booked_elsewhere': 'cancel_reason_booked_elsewhere',
    'no_longer_needed': 'cancel_reason_no_longer_needed',
    'other': 'cancel_reason_other',
  };

  @override
  Widget build(BuildContext context) {
    final label = reason.label != null && reason.label!.isNotEmpty
        ? reason.label!
        : (_fallbackLabels[reason.key] != null
            ? _fallbackLabels[reason.key]!.tr()
            : (reason.key ?? ''));
    return AppChoiceChip(
      label: label,
      selected: selected,
      onTap: onTap,
    );
  }
}
