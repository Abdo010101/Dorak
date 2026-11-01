import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:dorakpattient/features/home/logic/bottom_nav_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_state.dart';
import 'package:dorakpattient/features/profile/presentation/pages/profile_page.dart';
import 'package:dorakpattient/features/profile/presentation/widgets/guest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_harness.dart';

class _MockAuthRepo extends Mock implements AuthenticationRepository {}

class _MockPrefs extends Mock implements SharedPref {}

class _MockProfileRepo extends Mock implements ProfileRepository {}

class _FakeAuthCubit extends AuthCubit {
  _FakeAuthCubit(AuthState seed, AuthenticationRepository repo, SharedPref prefs)
      : super(authenticationRepository: repo, sharedPref: prefs) {
    emit(seed);
  }

  @override
  Future<void> loadCurrentUser() async {}
}

class _FakePatientProfileCubit extends PatientProfileCubit {
  _FakePatientProfileCubit(PatientProfileState seed, ProfileRepository repo)
      : super(profileRepository: repo) {
    emit(seed);
  }

  @override
  Future<void> load() async {}
}

void main() {
  setUpAll(setUpTestHarness);

  late _MockAuthRepo authRepo;
  late _MockPrefs prefs;
  late _MockProfileRepo profileRepo;
  late BottomNavCubit navCubit;

  setUp(() {
    silenceOverflowErrors();
    authRepo = _MockAuthRepo();
    prefs = _MockPrefs();
    profileRepo = _MockProfileRepo();
    navCubit = BottomNavCubit();
  });

  Future<void> pumpProfile(
    WidgetTester tester, {
    required AuthState authState,
    PatientProfileState profileState = const PatientProfileState(),
  }) async {
    final auth = _FakeAuthCubit(authState, authRepo, prefs);
    final profile = _FakePatientProfileCubit(profileState, profileRepo);
    addTearDown(() async {
      await auth.close();
      await profile.close();
      await navCubit.close();
    });
    await pumpApp(
      tester,
      const ProfilePage(),
      surfaceSize: const Size(412, 2000),
      providers: [
        BlocProvider<AuthCubit>.value(value: auth),
        BlocProvider<PatientProfileCubit>.value(value: profile),
        BlocProvider<BottomNavCubit>.value(value: navCubit),
      ],
    );
  }

  testWidgets('guest state renders GuestCard', (tester) async {
    await pumpProfile(tester, authState: const AuthState());
    expect(find.byType(GuestCard), findsOneWidget);
  });

  testWidgets('signed-in state hides GuestCard', (tester) async {
    final signedIn = AuthState(
      user: UserResponse(
        token: 'Bearer t.o.k.e.n',
        patient: Patient(id: 1, name: 'أحمد', phone: '555123456'),
      ),
    );
    await pumpProfile(tester, authState: signedIn);
    expect(find.byType(GuestCard), findsNothing);
  });

  testWidgets('bookings-row tap flips BottomNavCubit to index 2',
      (tester) async {
    final signedIn = AuthState(
      user: UserResponse(
        token: 'Bearer t.o.k.e.n',
        patient: Patient(id: 1, name: 'أحمد', phone: '555123456'),
      ),
    );
    await pumpProfile(tester, authState: signedIn);
    expect(navCubit.state, 0);
    final bookingsRow = find.text('nav_bookings'.toString()).hitTestable();
    // Row label is a .tr() key — look up ar translation 'حجوزاتي'.
    final arabic = find.text('حجوزاتي');
    expect(arabic, findsOneWidget);
    await tester.tap(arabic);
    await tester.pump();
    expect(navCubit.state, 2);
    bookingsRow.toString(); // keep lint happy
  });
}
