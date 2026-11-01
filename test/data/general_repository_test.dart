import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/fixture_reader.dart';
import '../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements GeneralClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late GeneralRepository repo;

  setUp(() {
    client = _MockClient();
    repo = GeneralRepository(generalClient: client);
  });

  test('getGeneralData success — parses envelope', () async {
    final fx = jsonFixture('general/general_success.json');
    final data =
        GeneralResponse.fromJson(fx['data'] as Map<String, dynamic>);
    when(() => client.getGeneralData())
        .thenAnswer((_) async => BaseResponse<GeneralResponse>(data: data));

    final result = await repo.getGeneralData();

    expect(result.error, isNull);
    expect(result.data, isA<GeneralResponse>());
  });
}
