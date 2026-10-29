import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum BookingStatus { confirmed, pending, completed, cancelled }

class BookingData {
  const BookingData({
    required this.status,
    required this.dateTime,
    required this.centerName,
    required this.doctorService,
    required this.branchCity,
    required this.imageAsset,
  });

  final BookingStatus status;
  final String dateTime;
  final String centerName;
  final String doctorService;
  final String branchCity;
  final String imageAsset;
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.data, this.onTap});
  final BookingData data;
  final VoidCallback? onTap;

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
          // Figma shadow-card; promoted to AppShadows in Phase B.
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
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
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
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.secondaryTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'booking_card_details'.tr(),
                    style: typo.textLgSemibold.copyWith(
                      color: colors.textInfo,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    // Pending/cancelled palettes are not in the theme yet; added in Phase B
    // (warningBg25/textWarning + errorBg25/textError). Confirmed/completed
    // map to existing tokens.
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
          colors.secondaryTint,
          colors.textInfo,
          'status_completed'.tr(),
        ),
      BookingStatus.cancelled => (
          const Color(0xFFFEE4E2),
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
