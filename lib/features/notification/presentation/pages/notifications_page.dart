import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Account 08 Notifications (Figma `209:2971`).
///
/// Material icons stand in for Figma Hicon icons on the row pills.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _accent = Color(0xFF1F8046);
  static const _accentBg = Color(0xFFEFFFF3);
  static const _primary50 = Color(0xFFDBFEE3);
  static const _secondary50 = Color(0xFFE5EFFF);
  static const _warning50 = Color(0xFFFFFAEB);
  static const _borderTertiary = Color(0xFFE5E5E5);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => context.canPop() ? context.pop() : null),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _SectionHeader(
                    title: 'notif_today'.tr(),
                    action: 'notif_mark_all'.tr(),
                    onAction: () {},
                  ),
                  const SizedBox(height: 10),
                  const _NotificationItem(
                    unread: true,
                    title: 'تذكير بموعدك',
                    body: 'موعدك غدًا الساعة ٤:٣٠ م مع د. أحمد العلي في مجمع النور الطبي.',
                    time: 'منذ ١٠ دقائق',
                    icon: Icons.calendar_today_outlined,
                    iconBg: _primary50,
                    iconColor: _accent,
                  ),
                  const SizedBox(height: 10),
                  const _NotificationItem(
                    unread: true,
                    title: 'تم تأكيد حجزك',
                    body: 'رقم الحجز DR-48213. يمكنك متابعة التفاصيل من حجوزاتي.',
                    time: 'منذ ساعتين',
                    icon: Icons.check,
                    iconBg: _primary50,
                    iconColor: _accent,
                  ),
                  const SizedBox(height: 14),
                  _SectionHeader(title: 'notif_this_week'.tr()),
                  const SizedBox(height: 10),
                  const _NotificationItem(
                    unread: false,
                    title: 'عرض جديد قريب منك',
                    body: 'خصم على تنظيف الأسنان في مركز العناية الطبي حتى نهاية الشهر.',
                    time: 'أمس',
                    icon: Icons.local_offer_outlined,
                    iconBg: _secondary50,
                    iconColor: Color(0xFF175CD3),
                  ),
                  const SizedBox(height: 10),
                  const _NotificationItem(
                    unread: false,
                    title: 'قيّم زيارتك',
                    body: 'كيف كانت زيارتك لمجمع النور الطبي؟ رأيك يساعد الآخرين.',
                    time: 'منذ ٣ أيام',
                    icon: Icons.favorite_border,
                    iconBg: _warning50,
                    iconColor: Color(0xFFB54708),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          const Spacer(),
          Center(
            child: Text(
              'notif_title'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: NotificationsPage._textPrimary,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 24,
              color: NotificationsPage._textPrimary,
            ),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: NotificationsPage._accent,
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: NotificationsPage._textPrimary,
          ),
        ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.unread,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final bool unread;
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unread ? NotificationsPage._accentBg : Colors.white,
        border: Border.all(color: NotificationsPage._borderTertiary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: NotificationsPage._textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (unread) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: NotificationsPage._accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: NotificationsPage._textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    color: NotificationsPage._textSecondary,
                  ),
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
}
