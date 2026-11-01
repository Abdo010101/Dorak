import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements ProfileClient {}

void main() {
  final harness = installRepoHarness();
  late _MockClient client;
  late ProfileRepository repo;

  setUp(() {
    client = _MockClient();
    repo = ProfileRepository(profileClient: client);
  });

  test('getProfileData success — parses Patient', () async {
    final fx = jsonFixture('profile/patient_success.json');
    final patient = Patient.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getProfileData())
        .thenAnswer((_) async => BaseResponse<Patient>(data: patient));

    final result = await repo.getProfileData();

    expect(result.error, isNull);
    expect(result.data!.name, 'أحمد المريض');
    expect(result.data!.allowNotifications, 1);
  });

  test('updateProfile 422 — surfaces validation error', () async {
    when(() => client.updateProfile(any())).thenThrow(harness.dioError(
        statusCode: 422, fixturePath: 'auth/send_otp_422.json'));

    final result = await repo.updateProfile({'name': ''});

    expect(result.error!.statusCode, 422);
    expect(result.error!.message, 'رقم الجوال غير صحيح');
  });
}
