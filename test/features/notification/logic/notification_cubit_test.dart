import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/notification/logic/notification_cubit.dart';
import 'package:dorakpattient/features/notification/logic/notification_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotifsRepo extends Mock implements NotificationsRepository {}

void main() {
  late _MockNotifsRepo repo;

  setUp(() {
    repo = _MockNotifsRepo();
  });

  group('NotificationCubit', () {
    blocTest<NotificationCubit, NotificationFeedState>(
      'setEnabled flips flag',
      build: () => NotificationCubit(notificationsRepository: repo),
      act: (c) => c.setEnabled(true),
      expect: () =>
          const [NotificationFeedState(notificationsEnabled: true)],
    );

    blocTest<NotificationCubit, NotificationFeedState>(
      'loadFirstPage success replaces items',
      setUp: () {
        when(() => repo.getNotifications(pageKey: any(named: 'pageKey')))
            .thenAnswer(
          (_) async => BaseModel<List<NotificationModel>>(
            data: <NotificationModel>[],
          ),
        );
      },
      build: () => NotificationCubit(notificationsRepository: repo),
      act: (c) => c.loadFirstPage(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.items, isEmpty);
      },
    );
  });
}
