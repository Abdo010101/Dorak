import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Phase 11 — Account 05 Cancel booking (Figma `208:2641`). Modal body only;
/// mount via `showModalBottomSheet` or [AppBottomSheet.show].
class CancelBookingSheet extends StatefulWidget {
  const CancelBookingSheet({super.key, this.appointment});

  final AppointmentResponse? appointment;

  @override
  State<CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<CancelBookingSheet> {
  int? _reasonIndex;

  static const _reasonKeys = <String>[
    'cancel_reason_schedule_conflict',
    'cancel_reason_booked_elsewhere',
    'cancel_reason_no_longer_needed',
    'cancel_reason_other',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    const radii = Radius.circular(24);
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
              selected: _reasonIndex,
              reasonKeys: _reasonKeys,
              onTap: (i) => setState(() => _reasonIndex = i),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: 'cancel_booking_confirm'.tr(),
              onPressed: _confirm,
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
      if (idx >= 0) cubit.cancel(idx);
    }
    Navigator.of(context).maybePop();
  }
}

class _ReasonGrid extends StatelessWidget {
  const _ReasonGrid({
    required this.selected,
    required this.reasonKeys,
    required this.onTap,
  });
  final int? selected;
  final List<String> reasonKeys;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < reasonKeys.length; row += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                for (var col = 0; col < 2; col++)
                  if (row + col < reasonKeys.length) ...[
                    Expanded(
                      child: AppChoiceChip(
                        label: reasonKeys[row + col].tr(),
                        selected: selected == row + col,
                        onTap: () => onTap(row + col),
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
