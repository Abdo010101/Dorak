import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../widgets/booking_stepper.dart';
import '../widgets/booking_summary_header.dart';
import '../widgets/booking_tokens.dart';
import '../widgets/detail_row.dart';

/// UI-redesign booking flow — step 3: review & confirm.
///
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `438:12762`. Static mock; CTA
/// navigates to the confirmed screen until `BookingCubit.confirm()` wires in.
class BookingReviewPage extends StatelessWidget {
  const BookingReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: 'booking_review_title'.tr(),
              onBack: () => context.canPop() ? context.pop() : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                children: [
                  const BookingSummaryHeader(
                    name: 'عيادة دكتور احمد',
                    subtitle: 'فرع الفيصلية · الدمام',
                    backgroundColor: BookingTokens.secondarySurface,
                    imageSize: Size(64, 56),
                    padding: EdgeInsetsDirectional.only(start: 12, end: 8),
                  ),
                  const SizedBox(height: 16),
                  const BookingStepper(current: BookingStep.review),
                  const SizedBox(height: 16),
                  _SectionTitle('booking_details_header'.tr()),
                  const SizedBox(height: 12),
                  _DetailCard(
                    rows: [
                      DetailRow(
                        icon: Icons.person_outline,
                        label: 'booking_label_doctor'.tr(),
                        value: 'د. أحمد العلي',
                      ),
                      DetailRow(
                        icon: Icons.medical_services_outlined,
                        label: 'booking_label_service'.tr(),
                        value: 'كشف واستشارة أسنان',
                      ),
                      DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'booking_label_date'.tr(),
                        value: 'الخميس، ٢٢ أكتوبر ٢٠٢٦',
                      ),
                      DetailRow(
                        icon: Icons.access_time,
                        label: 'booking_label_time'.tr(),
                        value: '٤:٣٠ مساءً',
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle('booking_patient_payment'.tr()),
                  const SizedBox(height: 12),
                  _DetailCard(
                    rows: [
                      DetailRow(
                        icon: Icons.person_outline,
                        label: 'booking_label_patient'.tr(),
                        value: 'سارة أحمد',
                      ),
                      DetailRow(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'booking_label_fees'.tr(),
                        value: '١٥٠ ر.س',
                        valueColor: BookingTokens.accent,
                      ),
                      DetailRow(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'booking_label_payment'.tr(),
                        value: 'booking_payment_in_center'.tr(),
                        showDivider: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _PolicyNote(),
                ],
              ),
            ),
            _BottomBar(
              onConfirm: () => context.pushNamed(RouteNames.bookingConfirmed),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BookingTokens.textPrimary,
              ),
            ),
          ),
          PositionedDirectional(
            end: 4,
            top: 4,
            child: IconButton(
              icon: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
                size: 24,
                color: BookingTokens.textPrimary,
              ),
              onPressed: onBack,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: BookingTokens.textPrimary,
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.rows});
  final List<Widget> rows;

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
        child: Column(children: rows),
      ),
    );
  }
}

class _PolicyNote extends StatelessWidget {
  const _PolicyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BookingTokens.warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: BookingTokens.textPrimary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'booking_policy_note'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: BookingTokens.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onConfirm});
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0D1D1D1D),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 23, 16, 16),
        child: AppPrimaryButton(
          label: 'booking_confirm_cta'.tr(),
          onPressed: onConfirm,
          leadingIcon: const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
