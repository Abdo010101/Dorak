import 'package:dorakpattient/data/models/response/discovery_response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements DiscoveryClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late DiscoveryRepository repo;

  setUp(() {
    client = _MockClient();
    repo = DiscoveryRepository(client: client);
  });

  test('search success — parses specializations + sections', () async {
    final fx = jsonFixture('discovery/search_success.json');
    final data =
        SearchResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.search(
      search: any(named: 'search'),
      lat: any(named: 'lat'),
      lng: any(named: 'lng'),
      specializationId: any(named: 'specializationId'),
      perPage: any(named: 'perPage'),
    )).thenAnswer((_) async => data);

    final result = await repo.search(search: 'باطنة');

    expect(result.error, isNull);
    expect(result.data!.specializations, hasLength(1));
  });
}
