import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/state/status.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';
import '../widgets/booking_stepper.dart';
import '../widgets/booking_summary_header.dart';
import '../widgets/booking_tokens.dart';
import '../widgets/detail_row.dart';

/// UI-redesign booking flow — step 3: review & confirm.
///
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `438:12762`. Fetches the preview
/// via `POST /patient/booking/preview` (scope §10.1) and renders the
/// returned PatientReservationResource. Confirm calls
/// `BookingCubit.confirm()` → navigates to the confirmed screen on success.
class BookingReviewPage extends StatefulWidget {
  const BookingReviewPage({super.key});

  @override
  State<BookingReviewPage> createState() => _BookingReviewPageState();
}

class _BookingReviewPageState extends State<BookingReviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookingCubit>().loadPreview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<BookingCubit, BookingState>(
          listenWhen: (p, c) => p.booked != c.booked,
          listener: (ctx, s) {
            if (s.booked) {
              context.pushReplacementNamed(RouteNames.bookingConfirmed);
            }
          },
          builder: (context, s) {
            final preview = s.preview;
            final isLoading = s.previewStatus == Status.loading;
            return Column(
              children: [
                _TopBar(
                  title: 'booking_review_title'.tr(),
                  onBack: () => context.canPop() ? context.pop() : null,
                ),
                Expanded(
                  child: isLoading && preview == null
                      ? const Center(child: CircularProgressIndicator())
                      : _Content(preview: preview, errorMessage: s.errorMessage),
                ),
                _BottomBar(
                  busy: s.confirmStatus == Status.loading,
                  onConfirm: s.canConfirm
                      ? () => context.read<BookingCubit>().confirm()
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.preview, required this.errorMessage});
  final dynamic preview; // AppointmentResponse
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (preview == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          errorMessage ?? 'something_went_wrong'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: BookingTokens.textSecondary),
        ),
      );
    }
    final p = preview;
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      children: [
        BookingSummaryHeader(
          name: p.place?.name ?? '',
          subtitle: p.place?.branch ?? p.place?.address ?? '',
          backgroundColor: BookingTokens.secondarySurface,
          imageSize: const Size(64, 56),
          padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
        ),
        const SizedBox(height: 16),
        const BookingStepper(current: BookingStep.review),
        const SizedBox(height: 16),
        _SectionTitle('booking_details_header'.tr()),
        const SizedBox(height: 12),
        _DetailCard(
          rows: [
            DetailRow(
              icon: Icons.medical_services_outlined,
              label: 'booking_label_service'.tr(),
              value: p.service ?? p.specialization?.name ?? '—',
            ),
            DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'booking_label_date'.tr(),
              value: p.dateLabel ?? '—',
            ),
            DetailRow(
              icon: Icons.access_time,
              label: 'booking_label_time'.tr(),
              value: p.timeLabel ?? '—',
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
              icon: Icons.account_balance_wallet_outlined,
              label: 'booking_label_payment'.tr(),
              value: p.paymentMethod ?? 'booking_payment_in_center'.tr(),
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _PolicyNote(),
      ],
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
            child: AppBackButton(onPressed: onBack),
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
  const _BottomBar({required this.onConfirm, required this.busy});
  final VoidCallback? onConfirm;
  final bool busy;

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
          isLoading: busy,
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
