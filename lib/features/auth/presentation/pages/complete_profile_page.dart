import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 06 Complete profile (Figma `352:3260`).
class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  static const _brandGreen = Color(0xFF1F8046);
  static const _brandGreenGlow = Color(0xFF98F3B2);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(
        () => context.read<AuthCubit>().setName(_nameController.text));
    _emailController.addListener(
        () => context.read<AuthCubit>().setEmail(_emailController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final type = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (p, c) =>
              p.profileCompleted != c.profileCompleted && c.profileCompleted,
          listener: (context, state) =>
              context.goNamed(RouteNames.signedIn),
          builder: (context, state) {
            final loading = state.status == Status.loading;
            final valid = state.name.trim().isNotEmpty &&
                state.email.trim().isNotEmpty;
            return Column(
              children: [
                _TopBar(
                  color: colors.textPrimary,
                  onBack: () => context.canPop() ? context.pop() : null,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    children: [
                      Text(
                        'complete_profile_title'.tr(),
                        textAlign: TextAlign.right,
                        style: type.display.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'complete_profile_subtitle'.tr(),
                        textAlign: TextAlign.right,
                        style: type.textLgRegular
                            .copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      _LabeledField(
                        label: 'complete_profile_name_label'.tr(),
                        controller: _nameController,
                        colors: colors,
                        type: type,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'complete_profile_email_label'.tr(),
                        controller: _emailController,
                        colors: colors,
                        type: type,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
                _CtaBar(
                  enabled: valid && !loading,
                  loading: loading,
                  onPressed:
                      () => context.read<AuthCubit>().completeProfile(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.color});
  final VoidCallback? onBack;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_right
                  : Icons.chevron_left,
              size: 24,
              color: color,
            ),
            onPressed: onBack,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.colors,
    required this.type,
    required this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final AppColorsTheme colors;
  final AppTypography type;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            label,
            style: type.textMdSemibold.copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: colors.surfaceField,
            border: Border.all(color: colors.fieldBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            style: TextStyle(fontSize: 14, color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _CtaBar extends StatelessWidget {
  const _CtaBar({
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: _CompleteProfilePageState._brandGreenGlow,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: enabled
                    ? _CompleteProfilePageState._brandGreen
                    : const Color(0xFF4C4C4C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: enabled ? onPressed : null,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'complete_profile_cta'.tr(),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
