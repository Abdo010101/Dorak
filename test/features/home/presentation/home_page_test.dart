import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_state.dart';
import 'package:dorakpattient/features/home/logic/home_cubit.dart';
import 'package:dorakpattient/features/home/logic/home_state.dart';
import 'package:dorakpattient/features/home/presentation/pages/home_page.dart';
import 'package:dorakpattient/features/home/presentation/widgets/specialty_chip_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_harness.dart';

class _MockHomeRepo extends Mock implements HomeRepository {}

class _MockGeneralRepo extends Mock implements GeneralRepository {}

class _FakeHomeCubit extends HomeCubit {
  _FakeHomeCubit(HomeState seed, HomeRepository repo)
      : super(homeRepository: repo) {
    emit(seed);
  }

  @override
  Future<void> load() async {}
}

class _FakeGeneralCubit extends GeneralCubit {
  _FakeGeneralCubit(GeneralState seed, GeneralRepository repo)
      : super(generalRepository: repo) {
    emit(seed);
  }
}

void main() {
  setUpAll(setUpTestHarness);

  late _MockHomeRepo homeRepo;
  late _MockGeneralRepo generalRepo;

  setUp(() {
    silenceOverflowErrors();
    homeRepo = _MockHomeRepo();
    generalRepo = _MockGeneralRepo();
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    required HomeState homeState,
    GeneralState generalState = const GeneralState(
      locationStatus: LocationResolveStatus.resolved,
    ),
  }) async {
    final homeCubit = _FakeHomeCubit(homeState, homeRepo);
    final generalCubit = _FakeGeneralCubit(generalState, generalRepo);
    addTearDown(() async {
      await homeCubit.close();
      await generalCubit.close();
    });
    await pumpApp(
      tester,
      const HomePage(),
      surfaceSize: const Size(412, 2400),
      providers: [
        BlocProvider<HomeCubit>.value(value: homeCubit),
        BlocProvider<GeneralCubit>.value(value: generalCubit),
      ],
    );
  }

  testWidgets('empty API payload renders 4 empty-section placeholders',
      (tester) async {
    final home = HomeResponse(
      specializations: [Titles(id: 1, name: 'طب عام')],
      latestOffers: const [],
      nearestMedicalCenters: const [],
      nearestClinics: const [],
      bestDoctors: const [],
    );
    await pumpHome(
      tester,
      homeState: HomeState(status: Status.success, home: home),
    );
    expect(
      find.byIcon(Icons.inbox_outlined, skipOffstage: false),
      findsNWidgets(4),
    );
  });

  testWidgets('specialty chip renders and is tappable', (tester) async {
    final home = HomeResponse(
      specializations: [
        Titles(id: 1, name: 'طب عام'),
        Titles(id: 2, name: 'مخ وأعصاب'),
      ],
      latestOffers: const [],
      nearestMedicalCenters: const [],
      nearestClinics: const [],
      bestDoctors: const [],
    );
    await pumpHome(
      tester,
      homeState: HomeState(status: Status.success, home: home),
    );
    expect(find.byType(SpecialtyChipRow), findsOneWidget);
    expect(find.text('طب عام'), findsOneWidget);
    expect(find.text('مخ وأعصاب'), findsOneWidget);
    final chip = find.ancestor(
      of: find.text('طب عام'),
      matching: find.byType(InkWell),
    );
    expect(chip, findsOneWidget);
  });

  testWidgets('empty centers section shows the location-hint when location '
      'is not resolved', (tester) async {
    final home = HomeResponse(
      specializations: [Titles(id: 1, name: 'طب عام')],
      nearestMedicalCenters: const [],
      nearestClinics: const [],
      latestOffers: const [],
      bestDoctors: const [],
    );
    await pumpHome(
      tester,
      homeState: HomeState(status: Status.success, home: home),
    );
    expect(
      find.text(
        'فعّل تحديد الموقع لرؤية الأقرب إليك',
        skipOffstage: false,
      ),
      findsNWidgets(2),
    );
  });
}
