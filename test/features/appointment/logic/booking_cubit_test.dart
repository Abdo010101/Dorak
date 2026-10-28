import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/appointment/logic/booking_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/booking_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AvailableAppointmentRepository {}

void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    registerFallbackValue(<String, dynamic>{});
  });

  group('BookingCubit', () {
    blocTest<BookingCubit, BookingState>(
      'setDoctor + selectDay + selectTime makes canConfirm true',
      build: () =>
          BookingCubit(availableAppointmentRepository: repo),
      act: (c) {
        c.setDoctor(10);
        c.selectDay(Week());
        c.selectTime('09:00');
      },
      verify: (c) => expect(c.state.canConfirm, isTrue),
    );

    blocTest<BookingCubit, BookingState>(
      'confirm without selection emits failure',
      build: () =>
          BookingCubit(availableAppointmentRepository: repo),
      act: (c) => c.confirm(),
      verify: (c) {
        expect(c.state.status, Status.failure);
        expect(c.state.errorMessage, 'select_day_and_time');
      },
    );

    blocTest<BookingCubit, BookingState>(
      'confirm success flips booked flag',
      setUp: () {
        when(() => repo.makeReservations(data: any(named: 'data'))).thenAnswer(
          (_) async =>
              BaseModel<ReservationResponse>(data: ReservationResponse()),
        );
      },
      build: () =>
          BookingCubit(availableAppointmentRepository: repo),
      seed: () => BookingState(
        doctorId: 10,
        selectedDay: Week(),
        selectedTime: '09:00',
      ),
      act: (c) => c.confirm(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.booked, isTrue);
      },
    );
  });
}
