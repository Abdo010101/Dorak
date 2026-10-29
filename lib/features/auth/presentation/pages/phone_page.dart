import 'package:dorakpattient/core/router/route_names.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 8 — Auth 03 / 03b Phone number (Figma `201:1422` + `352:3204`).
/// Uses the shared [AppInputField] with a leading `+966` dial-code chip.
/// Field is LTR-forced (dial code + digits are universally LTR).
class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<AuthCubit>().setPhone(_controller.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().resetFlags();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          listenWhen: (p, c) => p.otpSent != c.otpSent && c.otpSent,
          listener: (context, state) => context.goNamed(RouteNames.otp),
          builder: (context, state) {
            final hasError =
                state.status == Status.failure && state.errorMessage != null;
            return Column(
              children: [
                _TopBar(
                  color: colors.textPrimary,
                  onBack: () => context.canPop() ? context.pop() : null,
                ),
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 24),
                    children: [
                      Text(
                        'phone_title'.tr(),
                        textAlign: TextAlign.start,
                        style: type.display.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'phone_subtitle'.tr(),
                        textAlign: TextAlign.start,
                        style: type.textLgRegular
                            .copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      AppInputField(
                        controller: _controller,
                        label: 'phone_label'.tr(),
                        hintText: '55 123 4567',
                        helperText: hasError ? null : 'phone_helper'.tr(),
                        errorText: hasError ? state.errorMessage!.tr() : null,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        forceLtr: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        leading: _DialCode(colors: colors, type: type),
                        onSubmitted: (_) => context.read<AuthCubit>().sendOtp(),
                      ),
                    ],
                  ),
                ),
                _CtaBar(
                  loading: state.status == Status.loading,
                  onPressed: () => context.read<AuthCubit>().sendOtp(),
                  brand: colors.borderPrimary,
                  glow: colors.primary200,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DialCode extends StatelessWidget {
  const _DialCode({required this.colors, required this.type});
  final AppColorsTheme colors;
  final AppTypography type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: colors.fieldBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '+966',
        style: type.textLgRegular.copyWith(color: colors.textSecondary),
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
    required this.loading,
    required this.onPressed,
    required this.brand,
    required this.glow,
  });
  final bool loading;
  final VoidCallback onPressed;
  final Color brand;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
        child: AppPrimaryButton(
          label: 'phone_cta'.tr(),
          isLoading: loading,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
