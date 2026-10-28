import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppointmentsRepo extends Mock implements AppointmentsRepository {}

void main() {
  late _MockAppointmentsRepo repo;

  setUp(() {
    repo = _MockAppointmentsRepo();
    registerFallbackValue(<String, dynamic>{});
  });

  group('AppointmentsCubit', () {
    blocTest<AppointmentsCubit, AppointmentsState>(
      'load success emits items',
      setUp: () {
        when(() => repo.getAllAppointments(any(),
                pageKey: any(named: 'pageKey')))
            .thenAnswer(
          (_) async => BaseModel<List<AppointmentResponse>>(
            data: <AppointmentResponse>[],
          ),
        );
      },
      build: () => AppointmentsCubit(appointmentsRepository: repo),
      act: (c) => c.load(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.items, isEmpty);
      },
    );

    blocTest<AppointmentsCubit, AppointmentsState>(
      'setTab(past) emits new tab and reloads',
      setUp: () {
        when(() => repo.getAllAppointments(any(),
                pageKey: any(named: 'pageKey')))
            .thenAnswer(
          (_) async => BaseModel<List<AppointmentResponse>>(
            data: <AppointmentResponse>[],
          ),
        );
      },
      build: () => AppointmentsCubit(appointmentsRepository: repo),
      act: (c) => c.setTab(AppointmentsTab.past),
      verify: (c) {
        expect(c.state.tab, AppointmentsTab.past);
      },
    );
  });
}
