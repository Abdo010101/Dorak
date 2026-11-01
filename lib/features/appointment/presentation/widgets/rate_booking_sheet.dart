import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/models/request/rate_request.dart';
import 'package:dorakpattient/data/repository/rate_repo.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Rate booking modal — Figma `420:3794` (typing) + `419:3595` (success).
/// Shown as a dialog from the past-bookings "add rating" button.
///
/// Submits via `POST /patient/ratings {doctor_id, rate, comment?}` (scope
/// §10.2). Only one rating per doctor; the backend requires a `completed`
/// visit and flips `can_rate` across all that patient's reservations with
/// the doctor on success — mobile needs no local "already rated" flag.
Future<void> showRateBookingSheet(
  BuildContext context, {
  required int doctorId,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0x4D161616),
    builder: (_) => _RateBookingDialog(doctorId: doctorId),
  );
}

class _RateBookingDialog extends StatefulWidget {
  const _RateBookingDialog({required this.doctorId});
  final int doctorId;

  @override
  State<_RateBookingDialog> createState() => _RateBookingDialogState();
}

class _RateBookingDialogState extends State<_RateBookingDialog> {
  int _rating = 0;
  final _controller = TextEditingController();
  bool _submitted = false;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit => _rating > 0 && !_submitting;

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    final result = await locator<RateRepository>().doctorRate(
      RateRequest(
        comment: _controller.text,
        rate: _rating,
        doctorId: widget.doctorId,
      ),
    );
    if (!mounted) return;
    if (result.error != null) {
      setState(() {
        _submitting = false;
        _errorMessage = result.error?.message;
      });
      return;
    }
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: _submitted
            ? _SuccessBody(onDone: () => Navigator.of(context).pop())
            : _TypingBody(
                rating: _rating,
                controller: _controller,
                canSubmit: _canSubmit,
                submitting: _submitting,
                errorMessage: _errorMessage,
                onRate: (v) => setState(() => _rating = v),
                onSubmit: _submit,
                onLater: () => Navigator.of(context).pop(),
              ),
      ),
    );
  }
}

class _TypingBody extends StatelessWidget {
  const _TypingBody({
    required this.rating,
    required this.controller,
    required this.canSubmit,
    required this.submitting,
    required this.errorMessage,
    required this.onRate,
    required this.onSubmit,
    required this.onLater,
  });

  final int rating;
  final TextEditingController controller;
  final bool canSubmit;
  final bool submitting;
  final String? errorMessage;
  final ValueChanged<int> onRate;
  final VoidCallback onSubmit;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'rate_booking_title'.tr(),
            textAlign: TextAlign.center,
            style: typo.titleMd.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'rate_booking_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: typo.textMdRegular.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 20),
          _StarRow(rating: rating, onRate: onRate),
          const SizedBox(height: 20),
          _ReviewField(controller: controller),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: typo.textMdRegular.copyWith(color: const Color(0xFFB42318)),
            ),
          ],
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'rate_booking_submit'.tr(),
            isDisabled: !canSubmit,
            isLoading: submitting,
            onPressed: canSubmit ? onSubmit : null,
          ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: 'rate_booking_later'.tr(),
            onPressed: onLater,
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.onRate});
  final int rating;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final value = i + 1;
        final selected = value <= rating;
        return SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => onRate(value),
            icon: Icon(
              selected ? Icons.star_rounded : Icons.star_border_rounded,
              size: 32,
              color: selected ? colors.borderPrimary : const Color(0xFF949494),
            ),
          ),
        );
      }),
    );
  }
}

class _ReviewField extends StatelessWidget {
  const _ReviewField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return SizedBox(
      height: 104,
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: typo.textMdRegular.copyWith(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: 'rate_booking_review_hint'.tr(),
          hintStyle: typo.textMdRegular.copyWith(color: colors.textSecondary),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.borderPrimary, width: 1),
          ),
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 112,
            height: 112,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 76,
              height: 76,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.borderPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 36, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'rate_booking_success_title'.tr(),
            textAlign: TextAlign.center,
            style: typo.titleMd.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'rate_booking_success_body'.tr(),
            textAlign: TextAlign.center,
            style: typo.textMdRegular.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'rate_booking_done'.tr(),
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
