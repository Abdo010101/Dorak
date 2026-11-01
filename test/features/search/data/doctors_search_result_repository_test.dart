import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements DoctorsSearchResultClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late DoctorsSearchResultRepository repo;

  setUp(() {
    client = _MockClient();
    repo = DoctorsSearchResultRepository(searchResultClient: client);
  });

  test('getDoctors success — parses doctor list + price range', () async {
    final fx = jsonFixture('search/results_success.json');
    final results =
        SearchResultResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getDoctorsResults(any())).thenAnswer(
        (_) async => BaseResponse<SearchResultResponse>(data: results));

    final result = await repo.getDoctors({'specialization_id': 1}, 1);

    expect(result.error, isNull);
    expect(result.data!.doctors!.data, hasLength(2));
    expect(result.data!.minPrice, '100');
    expect(result.data!.maxPrice, '500');
  });
}
