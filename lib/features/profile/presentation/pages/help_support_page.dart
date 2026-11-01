import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

/// Phase 11 — Account 11 Help & support (Figma `363:3756`).
///
/// "Contact us" opens WhatsApp via `wa.me/<whatsapp_number>` where the
/// number comes from `/patient/general.whatsapp_number` (scope §10.1).
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(title: 'help_support_title'.tr()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
          child: _ListGroup(rows: [
            _RowSpec(
              icon: Icons.chat_bubble_outline,
              label: 'help_support_contact',
              onTap: () => _openWhatsApp(context),
            ),
            _RowSpec(
              icon: Icons.help_outline,
              label: 'help_support_faq',
              onTap: () {},
            ),
            _RowSpec(
              icon: Icons.description_outlined,
              label: 'help_support_terms',
              onTap: () {},
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final number = context
        .read<GeneralCubit>()
        .state
        .generalResponse
        ?.whatsappNumber;
    if (number == null || number.isEmpty) {
      AppSnackbar.show(
        context,
        'help_support_unavailable'.tr(),
        kind: AppSnackbarKind.error,
      );
      return;
    }
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$digits');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      AppSnackbar.show(
        context,
        'help_support_unavailable'.tr(),
        kind: AppSnackbarKind.error,
      );
    }
  }
}

class _RowSpec {
  const _RowSpec({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
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
    return InkWell(
      onTap: spec.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: hasDivider
              ? Border(bottom: BorderSide(color: colors.fieldBorder))
              : null,
        ),
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 20,
              color: colors.textSecondary,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.symmetric(horizontal: 12),
                child: Text(
                  spec.label.tr(),
                  textAlign: TextAlign.start,
                  style: typo.textLgSemibold.copyWith(color: colors.textPrimary),
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primaryTint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(spec.icon, size: 20, color: colors.borderPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
