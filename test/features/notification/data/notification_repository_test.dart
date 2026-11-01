import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../helpers/repo_test_harness.dart';

class _MockClient extends Mock implements NotificationClient {}

void main() {
  installRepoHarness();
  late _MockClient client;
  late NotificationsRepository repo;

  setUp(() {
    client = _MockClient();
    repo = NotificationsRepository(notificationsClient: client);
  });

  test('getNotifications success — parses list + read_at nullable', () async {
    final fx = jsonFixture('notification/list_success.json');
    final list = (fx['data'] as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
    when(() => client.getNotifications(any())).thenAnswer(
        (_) async => BaseResponseList<NotificationModel>(data: list));

    final result = await repo.getNotifications(pageKey: 1);

    expect(result.error, isNull);
    expect(result.data, hasLength(2));
  });
}
