import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileRepo extends Mock implements ProfileRepository {}

class _FakePatient extends Fake implements Patient {}

void main() {
  late _MockProfileRepo repo;

  setUpAll(() {
    registerFallbackValue(_FakePatient());
  });

  setUp(() {
    repo = _MockProfileRepo();
  });

  group('PatientProfileCubit', () {
    blocTest<PatientProfileCubit, PatientProfileState>(
      'setName/setPhone/setEmail/setGender emits form state',
      build: () => PatientProfileCubit(profileRepository: repo),
      act: (c) {
        c.setName('A');
        c.setPhone('5551234567');
        c.setEmail('a@b.com');
        c.setGender('male');
      },
      verify: (c) {
        expect(c.state.name, 'A');
        expect(c.state.phone, '5551234567');
        expect(c.state.email, 'a@b.com');
        expect(c.state.gender, 'male');
      },
    );

    blocTest<PatientProfileCubit, PatientProfileState>(
      'load success populates fields',
      setUp: () {
        final patient = Patient(
          name: 'Sara',
          phone: '0555',
          email: 's@d.com',
          gender: 'female',
        );
        when(() => repo.getProfileData())
            .thenAnswer((_) async => BaseModel<Patient>(data: patient));
      },
      build: () => PatientProfileCubit(profileRepository: repo),
      act: (c) => c.load(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.name, 'Sara');
      },
    );

    blocTest<PatientProfileCubit, PatientProfileState>(
      'update success sets updated=true',
      setUp: () {
        when(() => repo.updateProfile(any()))
            .thenAnswer((_) async => BaseModel<Patient>(data: Patient()));
      },
      build: () => PatientProfileCubit(profileRepository: repo),
      seed: () => const PatientProfileState(name: 'A', phone: '0'),
      act: (c) => c.update(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.updated, isTrue);
      },
    );
  });
}
