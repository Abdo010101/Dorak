import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/ui_kit/ui_kit.dart';
import '../widgets/booking_stepper.dart';
import '../widgets/booking_summary_header.dart';
import '../widgets/booking_tokens.dart';
import '../widgets/doctor_pick_tile.dart';
import '../widgets/specialty_chip_tile.dart';

/// UI-redesign booking flow — step 1: pick specialty and doctor.
///
/// Figma `jA3JQXye9DbBrxzNkEj9nf` node `177:888` (default) and `209:3151`
/// (doctor preselected). Static mock until `BookingCubit` wiring lands.
class BookingSpecialtyDoctorPage extends StatefulWidget {
  const BookingSpecialtyDoctorPage({
    super.key,
    this.preselectedDoctorId,
    this.preselectedSpecialtyId,
  });

  final int? preselectedDoctorId;
  final int? preselectedSpecialtyId;

  @override
  State<BookingSpecialtyDoctorPage> createState() =>
      _BookingSpecialtyDoctorPageState();
}

class _BookingSpecialtyDoctorPageState
    extends State<BookingSpecialtyDoctorPage> {
  static const _specialties = <_SpecialtyItem>[
    _SpecialtyItem(
        id: 1, icon: Icons.medical_services_outlined, label: 'طب الأسنان'),
    _SpecialtyItem(id: 2, icon: Icons.child_care_outlined, label: 'طب الأطفال'),
  ];

  static const _doctors = <_DoctorItem>[
    _DoctorItem(
      id: -1,
      name: 'أي طبيب متاح',
      subtitle: 'أقرب موعد لأي طبيب في العيادة',
      isAny: true,
    ),
    _DoctorItem(
      id: 1,
      name: 'د. أحمد العلي',
      subtitle: 'استشاري طب الأسنان',
      isAny: false,
    ),
    _DoctorItem(
      id: 2,
      name: 'د. سارة الحسن',
      subtitle: 'أخصائية تقويم الأسنان',
      isAny: false,
    ),
  ];

  late int? _selectedSpecialtyId = widget.preselectedSpecialtyId ?? 1;

  @override
  void initState() {
    super.initState();
    popIfGuest(context);
  }

  late int? _selectedDoctorId = widget.preselectedDoctorId;

  bool get _canContinue =>
      _selectedSpecialtyId != null && _selectedDoctorId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              title: 'booking_header_title'.tr(),
              onBack: () => context.canPop() ? context.pop() : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                children: [
                  const BookingSummaryHeader(
                    name: 'مجمع النور الطبي',
                    subtitle: 'فرع الفيصلية · الدمام',
                  ),
                  const SizedBox(height: 16),
                  const BookingStepper(current: BookingStep.specialtyDoctor),
                  const SizedBox(height: 8),
                  _SectionLabel('booking_step_specialty'.tr()),
                  const SizedBox(height: 12),
                  _SpecialtiesRow(
                    items: _specialties,
                    selectedId: _selectedSpecialtyId,
                    onTap: (id) => setState(() => _selectedSpecialtyId = id),
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel('booking_step_doctor'.tr()),
                  const SizedBox(height: 4),
                  Text(
                    'booking_step_doctor_subtitle'.tr(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 13,
                      color: BookingTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < _doctors.length; i++) ...[
                    _buildDoctor(_doctors[i]),
                    if (i != _doctors.length - 1) const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
            _BottomBar(
              onNext: _canContinue
                  ? () => context.pushNamed(RouteNames.bookingDateTime)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctor(_DoctorItem d) {
    final selected = d.id == _selectedDoctorId;
    void handleTap() => setState(() => _selectedDoctorId = d.id);
    if (d.isAny) {
      return DoctorPickTile.anyDoctor(
        name: 'booking_any_doctor'.tr(),
        subtitle: d.subtitle,
        selected: selected,
        onTap: handleTap,
      );
    }
    return DoctorPickTile(
      name: d.name,
      subtitle: d.subtitle,
      selected: selected,
      onTap: handleTap,
    );
  }
}

class _SpecialtyItem {
  const _SpecialtyItem({
    required this.id,
    required this.icon,
    required this.label,
  });
  final int id;
  final IconData icon;
  final String label;
}

class _DoctorItem {
  const _DoctorItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.isAny,
  });
  final int id;
  final String name;
  final String subtitle;
  final bool isAny;
}

class _SpecialtiesRow extends StatelessWidget {
  const _SpecialtiesRow({
    required this.items,
    required this.selectedId,
    required this.onTap,
  });

  final List<_SpecialtyItem> items;
  final int? selectedId;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: SpecialtyChipTile(
              icon: items[i].icon,
              label: items[i].label,
              selected: items[i].id == selectedId,
              onTap: () => onTap(items[i].id),
            ),
          ),
          if (i != items.length - 1) const SizedBox(width: 12),
        ],
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
            start: 4,
            top: 4,
            child: AppBackButton(onPressed: onBack),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: BookingTokens.textPrimary,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onNext});
  final VoidCallback? onNext;

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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 16),
        child: AppPrimaryButton(
          label: 'booking_cta_continue'.tr(),
          onPressed: onNext,
          trailingIcon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward
                : Icons.arrow_back,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
