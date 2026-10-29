import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/models/response/notification_response.dart';
import 'package:dorakpattient/features/notification/logic/notification_cubit.dart';
import 'package:dorakpattient/features/notification/logic/notification_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Phase 11 — Account 08 Notifications (Figma `209:2971`) and Account 08b
/// empty (Figma `352:3712`). Wires [NotificationCubit] with 4 states and
/// today / this-week grouping.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(title: 'notif_title'.tr()),
      body: SafeArea(
        top: false,
        child: BlocBuilder<NotificationCubit, NotificationFeedState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return AppStatusViewX.fromStatus(
                status: state.status,
                isEmpty: true,
                errorMessage: state.errorMessage,
                onRetry: () =>
                    context.read<NotificationCubit>().loadFirstPage(),
                empty: _EmptyState(),
                builder: (_) => const SizedBox.shrink(),
              );
            }
            final (today, week) = _group(state.items);
            return ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
              children: [
                if (today.isNotEmpty) ...[
                  _GroupHeader(
                    title: 'notif_today'.tr(),
                    action: 'notif_mark_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 10),
                  for (final n in today) ...[
                    _NotificationItem(data: n),
                    const SizedBox(height: 10),
                  ],
                ],
                if (week.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _GroupHeader(title: 'notif_this_week'.tr()),
                  const SizedBox(height: 10),
                  for (final n in week) ...[
                    _NotificationItem(data: n),
                    const SizedBox(height: 10),
                  ],
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  (List<NotificationModel>, List<NotificationModel>) _group(
      List<NotificationModel> items) {
    final today = <NotificationModel>[];
    final week = <NotificationModel>[];
    final now = DateTime.now();
    for (final n in items) {
      final dt = DateTime.tryParse(n.date ?? '');
      final isToday = dt != null &&
          dt.year == now.year &&
          dt.month == now.month &&
          dt.day == now.day;
      (isToday ? today : week).add(n);
    }
    return (today, week);
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return AppEmptyState(
      icon: Icon(
        Icons.notifications_off_outlined,
        size: 48,
        color: colors.borderPrimary,
      ),
      title: 'notifications_empty_title'.tr(),
      message: 'notifications_empty_body'.tr(),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Row(
      children: [
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: typo.textLgSemibold.copyWith(color: colors.borderPrimary),
            ),
          )
        else
          const SizedBox.shrink(),
        const Spacer(),
        Text(
          title,
          style: typo.titleSm.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.data});
  final NotificationModel data;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final (icon, iconBg, iconColor) = _iconFor(data.type, colors);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _relativeTime(data.date),
            style: typo.textMdRegular.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? '',
                  textAlign: TextAlign.start,
                  style: typo.textLgSemibold.copyWith(color: colors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  data.description ?? '',
                  textAlign: TextAlign.start,
                  style:
                      typo.textLgRegular.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ],
      ),
    );
  }

  (IconData, Color, Color) _iconFor(String? type, AppColorsTheme c) {
    switch (type) {
      case 'offer':
        return (Icons.local_offer_outlined, c.secondaryTint, c.textInfo);
      case 'review':
        return (
          Icons.favorite_border,
          const Color(0xFFFFFAEB),
          const Color(0xFFB54708)
        );
      case 'booking':
      default:
        return (Icons.calendar_today_outlined, c.primaryTint, c.borderPrimary);
    }
  }

  String _relativeTime(String? raw) {
    final dt = DateTime.tryParse(raw ?? '');
    if (dt == null) return raw ?? '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'time_minutes_ago'.tr(args: ['${diff.inMinutes}']);
    if (diff.inHours < 24) return 'time_hours_ago'.tr(args: ['${diff.inHours}']);
    if (diff.inDays == 1) return 'time_yesterday'.tr();
    return 'time_days_ago'.tr(args: ['${diff.inDays}']);
  }
}
