import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/general_response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGeneralRepository extends Mock implements GeneralRepository {}

GeneralResponse _responseWith({
  List<Titles>? mainSpecializations,
  List<Titles>? cities,
  List<Titles>? titles,
}) {
  final r = GeneralResponse();
  r.titles = titles ?? [];
  r.mainSpecializations = mainSpecializations ?? [];
  r.cities = cities ?? [];
  return r;
}

Titles _titles(int id, String name) {
  final t = Titles();
  t.id = id;
  t.name = name;
  return t;
}

void main() {
  late _MockGeneralRepository repo;

  setUp(() {
    repo = _MockGeneralRepository();
  });

  group('GeneralCubit', () {
    blocTest<GeneralCubit, GeneralState>(
      'getGeneralData success emits loading then success with lists',
      setUp: () {
        when(() => repo.getGeneralData()).thenAnswer(
          (_) async => BaseModel<GeneralResponse>(
            data: _responseWith(
              mainSpecializations: [_titles(1, 'Cardio')],
              cities: [_titles(10, 'Riyadh')],
              titles: [_titles(100, 'Dr')],
            ),
          ),
        );
      },
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.getGeneralData(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.specializations.length, 1);
        expect(c.state.areas.length, 1);
        expect(c.state.titles.length, 1);
      },
    );

    blocTest<GeneralCubit, GeneralState>(
      'onSelectedCity sets cityId',
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.onSelectedCity(7),
      expect: () => const [GeneralState(cityId: 7)],
    );

    blocTest<GeneralCubit, GeneralState>(
      'searchSpecialization filters by lowercase name',
      build: () => GeneralCubit(generalRepository: repo),
      seed: () => GeneralState(
        generalResponse: _responseWith(
          mainSpecializations: [
            _titles(1, 'Cardio'),
            _titles(2, 'Dentist'),
          ],
        ),
      ),
      act: (c) => c.searchSpecialization('car'),
      verify: (c) {
        expect(c.state.specializations.length, 1);
        expect(c.state.specializations.first.name, 'Cardio');
      },
    );

    blocTest<GeneralCubit, GeneralState>(
      'getSubSpeciality success populates both lists',
      setUp: () {
        when(() => repo.getSubSpeciality(any())).thenAnswer(
          (_) async => BaseModel<List<Titles>>(
            data: [_titles(5, 'Interventional')],
          ),
        );
      },
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.getSubSpeciality(1),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.specId, 1);
        expect(c.state.specializationId, 1);
        expect(c.state.subSpecializations.length, 1);
        expect(c.state.originalSubSpecializations.length, 1);
      },
    );

    blocTest<GeneralCubit, GeneralState>(
      'setLatLng clears cityId and areaId',
      build: () => GeneralCubit(generalRepository: repo),
      seed: () => const GeneralState(cityId: 1, areaId: 2),
      act: (c) => c.setLatLng(lat: 24.7, lng: 46.7),
      verify: (c) {
        expect(c.state.lat, 24.7);
        expect(c.state.lng, 46.7);
        expect(c.state.cityId, isNull);
        expect(c.state.areaId, isNull);
      },
    );
  });
}
