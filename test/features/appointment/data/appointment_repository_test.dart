import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements AppointmentClient {}

void main() {
  final harness = installRepoHarness();
  late _MockClient client;
  late AppointmentsRepository repo;

  setUp(() {
    client = _MockClient();
    repo = AppointmentsRepository(appointmentClient: client);
  });

  test('getAllAppointments success — returns parsed list', () async {
    final fx = jsonFixture('appointment/reservations_list_success.json');
    final list = (fx['data'] as List)
        .map((e) => AppointmentResponse.fromJson(e as Map<String, dynamic>))
        .toList();
    when(() => client.getAllAppointments(any(), any()))
        .thenAnswer((_) async => BaseResponse<List<AppointmentResponse>>(data: list));

    final result = await repo.getAllAppointments('upcoming', pageKey: 1);

    expect(result.error, isNull);
    expect(result.data, isNotNull);
    expect(result.data!.first.id, 101);
    expect(result.data!.first.status, 'confirmed');
  });

  test('getReservation success — parses detail envelope', () async {
    final fx = jsonFixture('appointment/reservation_detail_success.json');
    final res = BaseResponse<AppointmentResponse>(
      data: AppointmentResponse.fromJson(fx['data'] as Map<String, dynamic>),
    );
    when(() => client.getReservation(any())).thenAnswer((_) async => res);

    final result = await repo.getReservation(101);

    expect(result.error, isNull);
    expect(result.data!.bookingNumber, 'RSV-0001');
    expect(result.data!.canReschedule, true);
  });

  test('declineAppointment success — flips status to cancelled', () async {
    final fx = jsonFixture('appointment/decline_success.json');
    when(() => client.declineAppointment(any())).thenAnswer((_) async =>
        BaseResponse<AppointmentResponse>(
            data: AppointmentResponse.fromJson(fx['data'] as Map<String, dynamic>)));

    final result = await repo.declineAppointment({'reservation_id': 101});

    expect(result.error, isNull);
    expect(result.data!.status, 'cancelled');
  });

  test('getReservation 404 — surfaces statusCode on BaseModel.error',
      () async {
    when(() => client.getReservation(any())).thenThrow(
      harness.dioError(statusCode: 404, fixturePath: 'appointment/decline_success.json'),
    );

    final result = await repo.getReservation(9999);

    expect(result.data, isNull);
    expect(result.error!.statusCode, 404);
  });
}
