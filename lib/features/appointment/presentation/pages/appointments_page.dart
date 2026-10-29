import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_state.dart';
import 'package:dorakpattient/features/appointment/presentation/widgets/booking_card.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 11 — Account 01/02/03 My bookings (Figma `207:2279`, `207:2407`,
/// `307:2547`, `207:2525`). 3 tabs: upcoming / past / cancelled. Wires
/// [AppointmentsCubit]. RTL via directional alignment + `TextAlign.start`.
class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  void initState() {
    super.initState();
    popIfGuest(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthCubit>().state;
      if (!auth.isAuthenticated) return;
      context.read<AppointmentsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(4, 6, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          if (Navigator.of(context).canPop())
                            const AppBackButton()
                          else
                            const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 4, end: 12),
                              child: Text(
                                'appointments_title'.tr(),
                                textAlign: TextAlign.start,
                                style: typo.display
                                    .copyWith(color: colors.textPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(start: 12),
                        child: _Tabs(
                          current: state.tab,
                          onTap: (t) =>
                              context.read<AppointmentsCubit>().setTab(t),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _Body(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});
  final AppointmentsState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == Status.loading) {
      return const AppLoadingState();
    }
    if (state.status == Status.failure) {
      return AppErrorState(
        title: 'something_went_wrong'.tr(),
        message: state.errorMessage,
        onRetry: () => context.read<AppointmentsCubit>().load(),
        retryLabel: 'retry'.tr(),
      );
    }
    final items = state.items;
    if (items.isEmpty) {
      return _EmptyState(tab: state.tab);
    }
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final r = items[i];
        return BookingCard(
          data: _dataFrom(r, state.tab),
          onTap: () => context.pushNamed(
            RouteNames.bookingDetails,
            extra: r,
          ),
        );
      },
    );
  }

  BookingData _dataFrom(AppointmentResponse r, AppointmentsTab tab) {
    final status = switch (tab) {
      AppointmentsTab.cancelled => BookingStatus.cancelled,
      AppointmentsTab.past => BookingStatus.completed,
      AppointmentsTab.upcoming => _statusFromString(r.status) ??
          BookingStatus.confirmed,
    };
    final dateTime = [r.day, r.date, r.month]
        .where((s) => s != null && s.isNotEmpty)
        .join(' · ');
    return BookingData(
      status: status,
      dateTime: dateTime.isEmpty ? '—' : dateTime,
      centerName: r.name ?? '',
      doctorService: r.mainSpecialization ?? '',
      branchCity: r.phone ?? '',
      imageAsset: 'assets/images/home/center1.png',
    );
  }

  BookingStatus? _statusFromString(String? s) => switch (s) {
        'pending' => BookingStatus.pending,
        'confirmed' => BookingStatus.confirmed,
        'completed' => BookingStatus.completed,
        'cancelled' => BookingStatus.cancelled,
        _ => null,
      };
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tab});
  final AppointmentsTab tab;

  @override
  Widget build(BuildContext context) {
    final key = switch (tab) {
      AppointmentsTab.upcoming => 'appointments_empty_upcoming',
      AppointmentsTab.past => 'appointments_empty_past',
      AppointmentsTab.cancelled => 'appointments_empty_cancelled',
    };
    final colors = AppColorsTheme.of(context);
    return AppEmptyState(
      icon: Icon(
        Icons.event_available_outlined,
        size: 48,
        color: colors.borderPrimary,
      ),
      title: 'appointments_empty_title'.tr(),
      message: key.tr(),
      actionLabel: tab == AppointmentsTab.upcoming
          ? 'book_appointment'.tr()
          : null,
      onAction: tab == AppointmentsTab.upcoming
          ? () => context.goNamed(RouteNames.home)
          : null,
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.current, required this.onTap});
  final AppointmentsTab current;
  final ValueChanged<AppointmentsTab> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    const tabs = AppointmentsTab.values;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final t = tabs[i];
          final active = t == current;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(t),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: active
                      ? const [
                          BoxShadow(
                            color: Color(0x0D101828),
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _labelKey(t).tr(),
                  style: typo.textLgSemibold.copyWith(
                    color: active ? colors.borderPrimary : colors.textSecondary,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _labelKey(AppointmentsTab t) => switch (t) {
        AppointmentsTab.upcoming => 'appointments_tab_upcoming',
        AppointmentsTab.past => 'appointments_tab_past',
        AppointmentsTab.cancelled => 'appointments_tab_cancelled',
      };
}
