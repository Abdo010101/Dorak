import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements HomeClient {}

void main() {
  final harness = installRepoHarness();
  late _MockClient client;
  late HomeRepository repo;

  setUp(() {
    client = _MockClient();
    repo = HomeRepository(homeClient: client);
  });

  test('getHomeData success — unreadNotificationsCount parsed', () async {
    final fx = jsonFixture('home/home_success.json');
    final home = HomeResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getHomeData())
        .thenAnswer((_) async => BaseResponse<HomeResponse>(data: home));

    final result = await repo.getHomeData();

    expect(result.error, isNull);
    expect(result.data!.unreadNotificationsCount, 2);
    expect(result.data!.specializations, hasLength(1));
  });

  test('getHomeData 500 — error surfaces statusCode', () async {
    when(() => client.getHomeData()).thenThrow(
      harness.dioError(statusCode: 500, fixturePath: 'home/home_success.json'),
    );

    final result = await repo.getHomeData();

    expect(result.data, isNull);
    expect(result.error!.statusCode, 500);
  });
}
