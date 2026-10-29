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

  static const _borderTertiary = Color(0xFFE5E5E5);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _tonalBg = Color(0xFFE5EFFF);
  static const _tonalText = Color(0xFF175CD3);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderTertiary),
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
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
          const Divider(height: 1, color: _borderTertiary),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.centerName,
                      style: const TextStyle(fontSize: 13, color: _textSecondary),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.doctorService,
                      style: const TextStyle(fontSize: 13, color: _textSecondary),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.branchCity,
                          style: const TextStyle(
                            fontSize: 13,
                            color: _textSecondary,
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
                  color: _tonalBg,
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
                    color: _tonalBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'booking_card_details'.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _tonalText,
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
    final (bg, fg, label) = switch (status) {
      BookingStatus.confirmed => (const Color(0xFFDBFEE3), const Color(0xFF1F8046), 'status_confirmed'.tr()),
      BookingStatus.pending => (const Color(0xFFFFFAEB), const Color(0xFFB54708), 'status_pending'.tr()),
      BookingStatus.completed => (const Color(0xFFE5EFFF), const Color(0xFF175CD3), 'status_completed'.tr()),
      BookingStatus.cancelled => (const Color(0xFFFEE4E2), const Color(0xFFB42318), 'status_canceled'.tr()),
    };
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}
