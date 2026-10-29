import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
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
                      AppInputField(
                        label: 'complete_profile_name_label'.tr(),
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      AppEmailField(
                        label: 'complete_profile_email_label'.tr(),
                        controller: _emailController,
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
          AppBackButton(onPressed: onBack),
          const Spacer(),
        ],
      ),
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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 14),
        child: AppPrimaryButton(
          label: 'complete_profile_cta'.tr(),
          isLoading: loading,
          isDisabled: !enabled,
          onPressed: enabled ? onPressed : null,
        ),
      ),
    );
  }
}
