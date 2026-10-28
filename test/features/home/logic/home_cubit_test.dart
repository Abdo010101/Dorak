import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/home/logic/bottom_nav_cubit.dart';
import 'package:dorakpattient/features/home/logic/home_cubit.dart';
import 'package:dorakpattient/features/home/logic/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHomeRepo extends Mock implements HomeRepository {}

void main() {
  late _MockHomeRepo repo;

  setUp(() {
    repo = _MockHomeRepo();
  });

  group('HomeCubit', () {
    blocTest<HomeCubit, HomeState>(
      'load success populates all lists',
      setUp: () {
        final home = HomeResponse();
        home.bestDoctors = [Doctor(), Doctor()];
        home.latestOffers = [OfferResponse()];
        home.patientReservations = [AppointmentResponse()];
        when(() => repo.getHomeData())
            .thenAnswer((_) async => BaseModel<HomeResponse>(data: home));
      },
      build: () => HomeCubit(homeRepository: repo),
      act: (c) => c.load(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.bestDoctors.length, 2);
        expect(c.state.latestOffers.length, 1);
        expect(c.state.appointments.length, 1);
      },
    );
  });

  group('BottomNavCubit', () {
    blocTest<BottomNavCubit, int>(
      'setIndex emits new index',
      build: () => BottomNavCubit(),
      act: (c) => c.setIndex(2),
      expect: () => const [2],
    );

    blocTest<BottomNavCubit, int>(
      'setIndex same index does not emit',
      build: () => BottomNavCubit(),
      act: (c) => c.setIndex(0),
      expect: () => const <int>[],
    );
  });
}
