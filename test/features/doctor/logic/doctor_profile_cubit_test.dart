import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/doctor/logic/doctor_profile_cubit.dart';
import 'package:dorakpattient/features/doctor/logic/doctor_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDoctorRepo extends Mock implements DoctorProfileRepository {}

void main() {
  late _MockDoctorRepo repo;

  setUp(() {
    repo = _MockDoctorRepo();
  });

  group('DoctorProfileCubit', () {
    blocTest<DoctorProfileCubit, DoctorProfileState>(
      'setTab emits new tab',
      build: () => DoctorProfileCubit(doctorProfileRepository: repo),
      act: (c) => c.setTab(DoctorProfileTab.offers),
      expect: () => const [DoctorProfileState(tab: DoctorProfileTab.offers)],
    );

    blocTest<DoctorProfileCubit, DoctorProfileState>(
      'load success sets profile and auto-selects first place',
      setUp: () {
        final doctor = DoctorProfileResponse();
        doctor.places = [Places(), Places()];
        when(() => repo.getDoctorProfile(doctorId: any(named: 'doctorId')))
            .thenAnswer(
          (_) async => BaseModel<DoctorProfileResponse>(data: doctor),
        );
      },
      build: () => DoctorProfileCubit(doctorProfileRepository: repo),
      act: (c) => c.load(42),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.selectedPlaceIndex, 0);
      },
    );

    blocTest<DoctorProfileCubit, DoctorProfileState>(
      'selectPlace emits new index',
      build: () => DoctorProfileCubit(doctorProfileRepository: repo),
      seed: () => DoctorProfileState(
        profile: DoctorProfileResponse()..places = [Places(), Places()],
        selectedPlaceIndex: 0,
      ),
      act: (c) => c.selectPlace(1),
      verify: (c) => expect(c.state.selectedPlaceIndex, 1),
    );
  });
}
