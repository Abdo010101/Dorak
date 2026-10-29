import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum BookingStatus { confirmed, pending, completed, cancelled }

/// Action footer variant per Figma `207:2279` / `207:2407` / `307:2547`:
/// upcoming → call icon + Details tonal; past → Add rating tonal full width;
/// cancelled → no actions.
enum BookingActions { upcomingCallDetails, pastAddRating, none }

class BookingData {
  const BookingData({
    required this.status,
    required this.dateTime,
    required this.centerName,
    required this.doctorService,
    required this.branchCity,
    required this.imageAsset,
    this.actions = BookingActions.upcomingCallDetails,
  });

  final BookingStatus status;
  final String dateTime;
  final String centerName;
  final String doctorService;
  final String branchCity;
  final String imageAsset;
  final BookingActions actions;
}

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.data,
    this.onTap,
    this.onCall,
    this.onDetails,
    this.onRate,
  });

  final BookingData data;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onDetails;
  final VoidCallback? onRate;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final card = Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1D1D1D),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _StatusBadge(status: data.status),
              const Spacer(),
              Row(
                children: [
                  Text(
                    data.dateTime,
                    style: typo.textLgSemibold.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  SvgPicture.asset(
                    'assets/images/home/calendar.svg',
                    width: 16,
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.fieldBorder),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.centerName,
                      style: typo.textMdRegular.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.doctorService,
                      style: typo.textMdRegular.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.branchCity,
                          style: typo.textMdRegular.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/images/home/location.svg',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  data.imageAsset,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          if (data.actions != BookingActions.none) ...[
            const SizedBox(height: 12),
            _Actions(
              variant: data.actions,
              onCall: onCall,
              onDetails: onDetails,
              onRate: onRate,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: card,
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.variant,
    this.onCall,
    this.onDetails,
    this.onRate,
  });

  final BookingActions variant;
  final VoidCallback? onCall;
  final VoidCallback? onDetails;
  final VoidCallback? onRate;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    switch (variant) {
      case BookingActions.pastAddRating:
        return _TonalButton(
          label: 'booking_card_add_rating'.tr(),
          onTap: onRate,
          bg: colors.secondaryTint,
          fg: colors.textInfo,
          typo: typo,
        );
      case BookingActions.upcomingCallDetails:
        return Row(
          children: [
            InkWell(
              onTap: onCall,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.secondaryTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/images/home/call.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TonalButton(
                label: 'booking_card_details'.tr(),
                onTap: onDetails,
                bg: colors.secondaryTint,
                fg: colors.textInfo,
                typo: typo,
              ),
            ),
          ],
        );
      case BookingActions.none:
        return const SizedBox.shrink();
    }
  }
}

class _TonalButton extends StatelessWidget {
  const _TonalButton({
    required this.label,
    required this.onTap,
    required this.bg,
    required this.fg,
    required this.typo,
  });

  final String label;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final AppTypography typo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: typo.textLgSemibold.copyWith(
            color: fg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final (bg, fg, label) = switch (status) {
      BookingStatus.confirmed => (
          colors.primaryTint,
          colors.borderPrimary,
          'status_confirmed'.tr(),
        ),
      BookingStatus.pending => (
          const Color(0xFFFFFAEB),
          colors.textWarning,
          'status_pending'.tr(),
        ),
      BookingStatus.completed => (
          const Color(0xFFF4F4F4),
          colors.textSecondary,
          'status_completed'.tr(),
        ),
      BookingStatus.cancelled => (
          const Color(0xFFFEF3F2),
          const Color(0xFFB42318),
          'status_canceled'.tr(),
        ),
    };
    return Container(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: typo.textMdRegular.copyWith(
          color: fg,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
