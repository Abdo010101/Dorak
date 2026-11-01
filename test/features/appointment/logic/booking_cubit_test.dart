import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/data/models/response/booking_response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/booking_repo.dart';
import 'package:dorakpattient/features/appointment/logic/booking_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/booking_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBookingRepo extends Mock implements BookingRepository {}

void main() {
  late _MockBookingRepo repo;

  setUp(() {
    repo = _MockBookingRepo();
    registerFallbackValue(<String, dynamic>{});
  });

  group('BookingCubit', () {
    blocTest<BookingCubit, BookingState>(
      'start seeds variant + doctorId; selectSlot after selectDay enables canPreview',
      build: () => BookingCubit(bookingRepository: repo),
      setUp: () {
        when(() => repo.slots(
              date: any(named: 'date'),
              doctorId: any(named: 'doctorId'),
              medicalCenterId: any(named: 'medicalCenterId'),
              specializationId: any(named: 'specializationId'),
            )).thenAnswer(
          (_) async => BaseModel<BookingSlotsResponse>(
            data: BookingSlotsResponse(),
          ),
        );
      },
      act: (c) async {
        c.start(variant: BookingVariant.center, doctorId: 10, medicalCenterId: 1);
        await c.selectDay(BookingDay(date: '2026-11-02'));
        c.selectSlot(BookingSlot(time: '09:00 AM'));
      },
      verify: (c) {
        expect(c.state.doctorId, 10);
        expect(c.state.canPreview, isTrue);
      },
    );

    blocTest<BookingCubit, BookingState>(
      'confirm success flips booked flag',
      setUp: () {
        when(() => repo.createReservation(
              doctorId: any(named: 'doctorId'),
              medicalCenterId: any(named: 'medicalCenterId'),
              date: any(named: 'date'),
              time: any(named: 'time'),
              note: any(named: 'note'),
            )).thenAnswer(
          (_) async =>
              BaseModel<AppointmentResponse>(data: AppointmentResponse()),
        );
      },
      build: () => BookingCubit(bookingRepository: repo),
      seed: () => BookingState(
        doctorId: 10,
        medicalCenterId: 1,
        selectedDay: BookingDay(date: '2026-11-02'),
        selectedSlot: BookingSlot(time: '09:00 AM'),
      ),
      act: (c) => c.confirm(),
      verify: (c) {
        expect(c.state.booked, isTrue);
      },
    );
  });
}
