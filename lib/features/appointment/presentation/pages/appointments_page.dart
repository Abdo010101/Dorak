import 'package:dorakpattient/features/appointment/presentation/widgets/booking_card.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Phase 8 — Account 01 My bookings (Figma `207:2279`).
///
/// Static mock data. `AppointmentsCubit` wiring lands with the Phase 5
/// AppointmentsController migration.
class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  int _tab = 0; // 0 upcoming, 1 past, 2 cancelled

  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _bgNeutral50 = Color(0xFFF4F4F4);
  static const _accent = Color(0xFF1F8046);

  List<BookingData> get _bookings {
    switch (_tab) {
      case 0:
        return const [
          BookingData(
            status: BookingStatus.confirmed,
            dateTime: 'الخميس ٢٢ أكتوبر · ٤:٣٠ م',
            centerName: 'مجمع النور الطبي',
            doctorService: 'د. أحمد العلي · كشف واستشارة أسنان',
            branchCity: 'فرع الفيصلية · الدمام',
            imageAsset: 'assets/images/home/center1.png',
          ),
          BookingData(
            status: BookingStatus.pending,
            dateTime: 'الأحد ٢ نوفمبر · ١٠:٠٠ ص',
            centerName: 'مركز العناية الطبي',
            doctorService: 'د. ريم السبيعي · فحص البشرة',
            branchCity: 'فرع الشاطئ · الدمام',
            imageAsset: 'assets/images/home/center2.png',
          ),
        ];
      case 1:
        return const [
          BookingData(
            status: BookingStatus.completed,
            dateTime: 'الاثنين ٥ أغسطس · ٣:٠٠ م',
            centerName: 'مجمع النور الطبي',
            doctorService: 'د. أحمد العلي · كشف',
            branchCity: 'فرع الفيصلية · الدمام',
            imageAsset: 'assets/images/home/center1.png',
          ),
        ];
      default:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'appointments_title'.tr(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _Tabs(
                    index: _tab,
                    onTap: (i) => setState(() => _tab = i),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _bookings.isEmpty
                  ? Center(
                      child: Text(
                        'appointments_empty'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: _textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemBuilder: (_, i) => BookingCard(data: _bookings[i]),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: _bookings.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const labels = ['القادمة', 'السابقة', 'الملغية'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _AppointmentsPageState._bgNeutral50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
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
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active
                        ? _AppointmentsPageState._accent
                        : _AppointmentsPageState._textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
