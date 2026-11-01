import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/data/models/response/booking_response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements BookingClient {}

void main() {
  final harness = installRepoHarness();
  late _MockClient client;
  late BookingRepository repo;

  setUp(() {
    client = _MockClient();
    repo = BookingRepository(client: client);
  });

  test('days success — parses available/full/closed cells', () async {
    final fx = jsonFixture('booking/days_success.json');
    final days = (fx['data'] as List)
        .map((e) => BookingDay.fromJson(e as Map<String, dynamic>))
        .toList();
    when(() => client.days(
        doctorId: any(named: 'doctorId'),
        medicalCenterId: any(named: 'medicalCenterId'),
        specializationId: any(named: 'specializationId'),
    )).thenAnswer((_) async => days);

    final result = await repo.days(doctorId: 7, medicalCenterId: 3);

    expect(result.error, isNull);
    expect(result.data, hasLength(3));
    expect(result.data!.first.isAvailable, isTrue);
    expect(result.data![1].isFull, isTrue);
    expect(result.data![2].isClosed, isTrue);
  });

  test('slots success — splits morning + evening lists', () async {
    final fx = jsonFixture('booking/slots_success.json');
    final slots = BookingSlotsResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.slots(
        date: any(named: 'date'),
        doctorId: any(named: 'doctorId'),
        medicalCenterId: any(named: 'medicalCenterId'),
        specializationId: any(named: 'specializationId'),
    )).thenAnswer((_) async => slots);

    final result = await repo.slots(date: '2026-11-02', doctorId: 7);

    expect(result.error, isNull);
    expect(result.data!.morning, hasLength(1));
    expect(result.data!.evening.first.available, isFalse);
  });

  test('createReservation success — returns pending reservation', () async {
    final fx = jsonFixture('booking/reservation_created.json');
    final res =
        AppointmentResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.createReservation(
        doctorId: any(named: 'doctorId'),
        medicalCenterId: any(named: 'medicalCenterId'),
        date: any(named: 'date'),
        time: any(named: 'time'),
        note: any(named: 'note'),
    )).thenAnswer((_) async => res);

    final result = await repo.createReservation(
      doctorId: 7,
      medicalCenterId: 3,
      date: '2026-11-02',
      time: '10:00',
    );

    expect(result.error, isNull);
    expect(result.data!.id, 202);
    expect(result.data!.status, 'pending');
  });

  test('preview 422 — error surfaces via BaseModel.error', () async {
    when(() => client.preview(
        doctorId: any(named: 'doctorId'),
        medicalCenterId: any(named: 'medicalCenterId'),
        date: any(named: 'date'),
        time: any(named: 'time'),
        note: any(named: 'note'),
    )).thenThrow(harness.dioError(
        statusCode: 422, fixturePath: 'booking/reservation_created.json'));

    final result = await repo.preview(
      doctorId: 7,
      medicalCenterId: 3,
      date: '2026-11-02',
      time: 'bad',
    );

    expect(result.data, isNull);
    expect(result.error!.statusCode, 422);
  });
}
