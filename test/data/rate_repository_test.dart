import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/fixture_reader.dart';
import '../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements RateClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late RateRepository repo;

  setUp(() {
    client = _MockClient();
    repo = RateRepository(rateClient: client);
  });

  test('doctorRate success — parses Ratings', () async {
    final fx = jsonFixture('rate/rate_success.json');
    final rating = Ratings.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.doctorRate(any()))
        .thenAnswer((_) async => BaseResponse<Ratings>(data: rating));

    final result = await repo.doctorRate({'doctor_id': 7, 'rate': 5});

    expect(result.error, isNull);
    expect(result.data!.rating, 5);
  });
}
