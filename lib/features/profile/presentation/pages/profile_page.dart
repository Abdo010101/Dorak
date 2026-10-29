import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_state.dart';
import 'package:dorakpattient/features/profile/presentation/widgets/guest_card.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 11 — Account 06 Profile signed-in (Figma `209:2649`) /
/// Account 07 Profile guest (Figma `209:2842`). Switches on
/// [AuthState.isAuthenticated]. RTL-first via directional alignment.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthCubit>().state;
      if (auth.isAuthenticated) {
        context.read<PatientProfileCubit>().load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, auth) {
            final isGuest = !auth.isAuthenticated;
            return ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 24),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'profile_title'.tr(),
                    textAlign: TextAlign.start,
                    style: typo.display.copyWith(color: colors.textPrimary),
                  ),
                ),
                const SizedBox(height: 14),
                if (isGuest) ...[
                  GuestCard(
                    onSignIn: () => context.goNamed(RouteNames.login),
                  ),
                  const SizedBox(height: 14),
                  _GroupHeader(label: 'profile_section_preferences'),
                  const SizedBox(height: 8),
                  _ListGroup(rows: _preferenceRows(context)),
                  const SizedBox(height: 14),
                  _ListGroup(rows: [
                    _RowSpec(
                      icon: Icons.help_outline,
                      label: 'profile_help_support',
                      onTap: () => context.pushNamed(RouteNames.helpSupport),
                    ),
                  ]),
                ] else ...[
                  BlocBuilder<PatientProfileCubit, PatientProfileState>(
                    builder: (_, state) {
                      final name = state.name.isNotEmpty
                          ? state.name
                          : auth.user?.patient?.name ?? '';
                      final phone = state.phone.isNotEmpty
                          ? state.phone
                          : auth.user?.patient?.phone ?? '';
                      final initial =
                          name.isNotEmpty ? name.characters.first : '؟';
                      return _UserCard(
                        name: name,
                        phone: phone,
                        initial: initial,
                        onEdit: () =>
                            context.pushNamed(RouteNames.personalInfo),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _GroupHeader(label: 'profile_section_account'),
                  const SizedBox(height: 8),
                  _ListGroup(rows: [
                    _RowSpec(
                      icon: Icons.person_outline,
                      label: 'profile_personal_info',
                      onTap: () => context.pushNamed(RouteNames.personalInfo),
                    ),
                    _RowSpec(
                      icon: Icons.calendar_today_outlined,
                      label: 'nav_bookings',
                      onTap: () => context.goNamed(RouteNames.appointments),
                    ),
                    _RowSpec(
                      icon: Icons.favorite_border,
                      label: 'profile_favorite_centers',
                      onTap: () =>
                          context.pushNamed(RouteNames.favouriteCenters),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  _GroupHeader(label: 'profile_section_preferences'),
                  const SizedBox(height: 8),
                  _ListGroup(rows: _preferenceRows(context)),
                  const SizedBox(height: 14),
                  _ListGroup(rows: [
                    _RowSpec(
                      icon: Icons.help_outline,
                      label: 'profile_help_support',
                      onTap: () => context.pushNamed(RouteNames.helpSupport),
                    ),
                    _RowSpec(
                      icon: Icons.logout,
                      label: 'profile_logout',
                      isDestructive: true,
                      onTap: () => context.read<AuthCubit>().logout(),
                    ),
                  ]),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  List<_RowSpec> _preferenceRows(BuildContext context) => [
        _RowSpec(
          icon: Icons.notifications_none,
          label: 'profile_notifications',
          trailingValue: 'profile_enabled',
          onTap: () => context.goNamed(RouteNames.notification),
        ),
        _RowSpec(
          icon: Icons.language,
          label: 'profile_language',
          trailingValue: 'profile_language_value',
          onTap: () => context.pushNamed(RouteNames.language),
        ),
        _RowSpec(
          icon: Icons.location_on_outlined,
          label: 'profile_city',
          trailingValue: 'profile_city_value',
          onTap: () {},
        ),
      ];
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.name,
    required this.phone,
    required this.initial,
    required this.onEdit,
  });
  final String name;
  final String phone;
  final String initial;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primaryTint,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.borderPrimary,
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: typo.display.copyWith(color: colors.onPrimary),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: typo.titleMd.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: typo.textLgSemibold.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Material(
            color: colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: colors.fieldBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_outlined,
                    size: 20, color: colors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Text(
        label.tr(),
        style: typo.textLgRegular.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _RowSpec {
  const _RowSpec({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingValue,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailingValue;
  final bool isDestructive;
}

class _ListGroup extends StatelessWidget {
  const _ListGroup({required this.rows});
  final List<_RowSpec> rows;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final r = rows[i];
          return _ListRow(spec: r, hasDivider: i != rows.length - 1);
        }),
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  const _ListRow({required this.spec, required this.hasDivider});
  final _RowSpec spec;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    final titleColor =
        spec.isDestructive ? const Color(0xFFB42318) : colors.textPrimary;
    final iconBg =
        spec.isDestructive ? const Color(0xFFFEF3F2) : colors.primaryTint;
    final iconColor =
        spec.isDestructive ? const Color(0xFFB42318) : colors.borderPrimary;
    return InkWell(
      onTap: spec.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: hasDivider
              ? Border(bottom: BorderSide(color: colors.fieldBorder))
              : null,
        ),
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(spec.icon, size: 20, color: iconColor),
            ),
            if (spec.trailingValue != null) ...[
              const SizedBox(width: 8),
              Text(
                spec.trailingValue!.tr(),
                style: typo.textMdRegular.copyWith(color: colors.textSecondary),
              ),
            ],
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                child: Text(
                  spec.label.tr(),
                  textAlign: TextAlign.start,
                  style: typo.textLgSemibold.copyWith(color: titleColor),
                ),
              ),
            ),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_right
                  : Icons.chevron_left,
              size: 20,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
