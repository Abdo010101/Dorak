import 'package:dorakpattient/data/models/response/centers_response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements CentersClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late CentersRepository repo;

  setUp(() {
    client = _MockClient();
    repo = CentersRepository(client: client);
  });

  test('listMedicalCenters success — parses list', () async {
    final fx = jsonFixture('centers/list_success.json');
    final list = (fx['data'] as List)
        .map((e) => MedicalCenterCard.fromJson(e as Map<String, dynamic>))
        .toList();
    when(() => client.listMedicalCenters(
      lat: any(named: 'lat'),
      lng: any(named: 'lng'),
      cityId: any(named: 'cityId'),
      areaId: any(named: 'areaId'),
      specializationId: any(named: 'specializationId'),
      search: any(named: 'search'),
      availableToday: any(named: 'availableToday'),
      radiusKm: any(named: 'radiusKm'),
      perPage: any(named: 'perPage'),
      page: any(named: 'page'),
    )).thenAnswer((_) async => list);

    final result = await repo.listMedicalCenters(cityId: 1, page: 1);

    expect(result.error, isNull);
    expect(result.data, hasLength(1));
  });
}
