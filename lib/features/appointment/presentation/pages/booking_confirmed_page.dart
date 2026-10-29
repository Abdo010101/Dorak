import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../widgets/booking_tokens.dart';
import '../widgets/detail_row.dart';

/// UI-redesign booking flow — step 4: confirmation.
///
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `438:12824`. Static mock; booking
/// number is a placeholder until `BookingCubit` returns the real id.
class BookingConfirmedPage extends StatelessWidget {
  const BookingConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 16),
                children: const [
                  _SuccessBadge(),
                  SizedBox(height: 20),
                  _Title(),
                  SizedBox(height: 8),
                  _Body(),
                  SizedBox(height: 24),
                  _SummaryCard(),
                ],
              ),
            ),
            _BottomActions(
              onViewBookings: () =>
                  context.goNamed(RouteNames.appointments),
              onBackHome: () => context.goNamed(RouteNames.home),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 112,
        height: 112,
        decoration: const BoxDecoration(
          color: BookingTokens.accentBg50,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: BookingTokens.accent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.check, size: 36, color: Colors.white),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      'booking_confirmed_title'.tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: BookingTokens.textPrimary,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Text(
      'booking_confirmed_body'.tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: BookingTokens.textSecondary,
        height: 1.4,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BookingTokens.borderNeutral),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1D1D1D),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              color: BookingTokens.accentBg25,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Text(
                    'booking_label_number'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: BookingTokens.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'DR-48213',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: BookingTokens.accent,
                    ),
                  ),
                ],
              ),
            ),
            DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'booking_label_appointment'.tr(),
              value: 'الخميس ٢٢ أكتوبر · ٤:٣٠ م',
            ),
            DetailRow(
              icon: Icons.location_on_outlined,
              label: 'booking_label_clinic'.tr(),
              value: 'مجمع النور الطبي',
            ),
            DetailRow(
              icon: Icons.medical_services_outlined,
              label: 'booking_label_service'.tr(),
              value: 'كشف واستشارة أسنان',
            ),
            DetailRow(
              icon: Icons.person_outline,
              label: 'booking_label_doctor'.tr(),
              value: 'د. أحمد العلي',
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onViewBookings,
    required this.onBackHome,
  });
  final VoidCallback onViewBookings;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppPrimaryButton(
              label: 'booking_see_my_bookings'.tr(),
              onPressed: onViewBookings,
            ),
            const SizedBox(height: 14),
            AppSecondaryButton(
              label: 'booking_back_to_home'.tr(),
              onPressed: onBackHome,
            ),
          ],
        ),
      ),
    );
  }
}
