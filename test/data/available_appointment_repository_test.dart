import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/fixture_reader.dart';
import '../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements AvailableAppointmentClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late AvailableAppointmentRepository repo;

  setUp(() {
    client = _MockClient();
    repo = AvailableAppointmentRepository(availableAppointmentClient: client);
  });

  test('getAvailableSchedules routes to clinic variant when id null',
      () async {
    final fx = jsonFixture('available_appointment/schedules_success.json');
    final data =
        AvailableSchedulesResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getAvailableSchedulesForClinic(
      doctorId: any(named: 'doctorId'),
    )).thenAnswer(
        (_) async => BaseResponse<AvailableSchedulesResponse>(data: data));

    final result = await repo.getAvailableSchedules(doctorId: 7);

    expect(result.error, isNull);
    expect(result.data!.schedules, hasLength(1));
    verify(() => client.getAvailableSchedulesForClinic(doctorId: 7)).called(1);
  });

  test('getAvailableSchedules routes to by-place when id present', () async {
    final fx = jsonFixture('available_appointment/schedules_success.json');
    final data =
        AvailableSchedulesResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getAvailableSchedulesByPlace(
      doctorId: any(named: 'doctorId'),
      id: any(named: 'id'),
    )).thenAnswer(
        (_) async => BaseResponse<AvailableSchedulesResponse>(data: data));

    final result = await repo.getAvailableSchedules(doctorId: 7, id: 3);

    expect(result.error, isNull);
    verify(() => client.getAvailableSchedulesByPlace(doctorId: 7, id: 3))
        .called(1);
  });
}
