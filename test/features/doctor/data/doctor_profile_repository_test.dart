import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements DoctorProfileClient {}

void main() {
  final harness = installRepoHarness();
  late _MockClient client;
  late DoctorProfileRepository repo;

  setUp(() {
    client = _MockClient();
    repo = DoctorProfileRepository(doctorProfileClient: client);
  });

  test('getDoctorProfile success — parses doctor + profile fields', () async {
    final fx = jsonFixture('doctor/profile_success.json');
    final doctor =
        DoctorProfileResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getDoctorProfile(id: any(named: 'id'))).thenAnswer(
        (_) async => BaseResponse<DoctorProfileResponse>(data: doctor));

    final result = await repo.getDoctorProfile(doctorId: 7);

    expect(result.error, isNull);
    expect(result.data!.doctor?.id, 7);
    expect(result.data!.profile?.experienceYears, 12);
  });

  test('getDoctorProfile 404 — error path', () async {
    when(() => client.getDoctorProfile(id: any(named: 'id'))).thenThrow(
      harness.dioError(statusCode: 404, fixturePath: 'doctor/profile_success.json'),
    );

    final result = await repo.getDoctorProfile(doctorId: 999);

    expect(result.data, isNull);
    expect(result.error!.statusCode, 404);
  });
}
