import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/core/theme/app_colors_theme.dart';
import 'package:dorakpattient/core/theme/app_typography.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Phase 11 — Account 09 Personal info (Figma `209:3066`).
///
/// 3 input fields (name / phone read-only with +966 prefix / email),
/// gender ChoiceChip pair, optional dob, "delete account" link, save CTA.
/// Wires [PatientProfileCubit].
class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  final TextEditingController _dob = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PatientProfileCubit>();
    final seed = cubit.state.profile ?? context.read<AuthCubit>().state.user?.patient;
    cubit.seedFrom(seed);
    _name = TextEditingController(text: cubit.state.name);
    _phone = TextEditingController(text: cubit.state.phone);
    _email = TextEditingController(text: cubit.state.email);
    _name.addListener(() => cubit.setName(_name.text));
    _email.addListener(() => cubit.setEmail(_email.text));
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _dob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Scaffold(
      backgroundColor: colors.white,
      appBar: AppTopBar(title: 'personal_info_title'.tr()),
      body: SafeArea(
        top: false,
        child: BlocConsumer<PatientProfileCubit, PatientProfileState>(
          listenWhen: (p, c) => !p.updated && c.updated,
          listener: (ctx, _) => ctx.canPop() ? ctx.pop() : null,
          builder: (context, state) {
            final loading = state.status == Status.loading;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 24),
                    children: [
                      AppInputField(
                        controller: _name,
                        label: 'personal_info_name_label'.tr(),
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      AppInputField(
                        controller: _phone,
                        label: 'personal_info_phone_label'.tr(),
                        helperText: 'personal_info_phone_helper'.tr(),
                        enabled: false,
                        leading: Container(
                          height: 44,
                          alignment: Alignment.center,
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: colors.fieldBorder),
                            ),
                          ),
                          child: Text(
                            '+966',
                            style: typo.textLgRegular.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppInputField(
                        controller: _email,
                        label: 'personal_info_email_label'.tr(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _GenderField(
                        current: state.gender,
                        onChanged: (g) =>
                            context.read<PatientProfileCubit>().setGender(g),
                      ),
                      const SizedBox(height: 16),
                      AppInputField(
                        controller: _dob,
                        label: 'personal_info_dob_label'.tr(),
                        readOnly: true,
                        onTap: () => _pickDate(context),
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton.icon(
                          onPressed: () => _confirmDeleteAccount(context),
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Color(0xFFB42318),
                          ),
                          label: Text(
                            'personal_info_delete_account'.tr(),
                            style: typo.textLgSemibold.copyWith(
                              color: const Color(0xFFB42318),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                    child: AppPrimaryButton(
                      label: 'personal_info_save'.tr(),
                      isLoading: loading,
                      onPressed:
                          () => context.read<PatientProfileCubit>().update(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );
    if (picked != null) {
      _dob.text =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('personal_info_delete_dialog_title'.tr()),
        content: Text('personal_info_delete_dialog_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'personal_info_delete_account'.tr(),
              style: const TextStyle(color: Color(0xFFB42318)),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      // TODO(wire): hook into profile repo deleteAccount when API lands.
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('personal_info_delete_pending'.tr())),
      );
    }
  }
}

class _GenderField extends StatelessWidget {
  const _GenderField({required this.current, required this.onChanged});
  final String? current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final typo = AppTypography.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'gender'.tr(),
            style: typo.textMdSemibold.copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: AppChoiceChip(
                label: 'gender_male'.tr(),
                selected: current == 'male',
                onTap: () => onChanged('male'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppChoiceChip(
                label: 'gender_female'.tr(),
                selected: current == 'female',
                onTap: () => onChanged('female'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
