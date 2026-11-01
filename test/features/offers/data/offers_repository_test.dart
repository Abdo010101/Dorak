import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements OffersClint {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late OffersRepository repo;

  setUp(() {
    client = _MockClient();
    repo = OffersRepository(offersClient: client);
  });

  test('getAllOffers success — parses envelope', () async {
    final fx = jsonFixture('offers/all_offers_success.json');
    final offers =
        AllOffersResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getAllOffers(any(), any())).thenAnswer(
        (_) async => BaseResponse<AllOffersResponse>(data: offers));

    final result = await repo.getAllOffers({'city_id': 1}, pageKey: 1);

    expect(result.error, isNull);
    expect(result.data, isA<AllOffersResponse>());
  });
}
