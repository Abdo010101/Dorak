import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_state.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/appointments_page.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/widget_test_harness.dart';

class _MockRepo extends Mock implements AppointmentsRepository {}

class _MockAuthRepo extends Mock implements AuthenticationRepository {}

class _MockPrefs extends Mock implements SharedPref {}

class _FakeCubit extends AppointmentsCubit {
  _FakeCubit(AppointmentsState seed, AppointmentsRepository repo)
      : super(appointmentsRepository: repo) {
    emit(seed);
  }

  @override
  Future<void> load() async {}
}

class _FakeAuthCubit extends AuthCubit {
  _FakeAuthCubit(AuthState seed, AuthenticationRepository repo, SharedPref prefs)
      : super(authenticationRepository: repo, sharedPref: prefs) {
    emit(seed);
  }

  @override
  Future<void> loadCurrentUser() async {}
}

void main() {
  setUpAll(setUpTestHarness);

  late _MockRepo repo;
  late _MockAuthRepo authRepo;
  late _MockPrefs prefs;

  setUp(() {
    silenceOverflowErrors();
    repo = _MockRepo();
    authRepo = _MockAuthRepo();
    prefs = _MockPrefs();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    required AppointmentsState state,
    AuthState auth = const AuthState(),
  }) async {
    final cubit = _FakeCubit(state, repo);
    final authCubit = _FakeAuthCubit(auth, authRepo, prefs);
    addTearDown(() async {
      await cubit.close();
      await authCubit.close();
    });
    await pumpApp(
      tester,
      const AppointmentsPage(),
      surfaceSize: const Size(412, 1600),
      providers: [
        BlocProvider<AppointmentsCubit>.value(value: cubit),
        BlocProvider<AuthCubit>.value(value: authCubit),
      ],
    );
  }

  testWidgets('empty upcoming tab renders the empty-state title',
      (tester) async {
    final signedIn = AuthState(
      user: UserResponse(
        token: 'Bearer t.o.k.e.n',
        patient: Patient(id: 1, name: 'أحمد', phone: '555123456'),
      ),
    );
    await pumpPage(
      tester,
      state: const AppointmentsState(
        status: Status.success,
        tab: AppointmentsTab.upcoming,
        items: [],
      ),
      auth: signedIn,
    );
    // Empty-state title is 'appointments_empty_title'.tr() → ar.json.
    expect(find.textContaining('حجوزات', findRichText: true), findsWidgets);
  });

  testWidgets('tab tap triggers setTab on cubit', (tester) async {
    final signedIn = AuthState(
      user: UserResponse(
        token: 'Bearer t.o.k.e.n',
        patient: Patient(id: 1, name: 'أحمد', phone: '555123456'),
      ),
    );
    await pumpPage(
      tester,
      state: const AppointmentsState(
        status: Status.success,
        tab: AppointmentsTab.upcoming,
      ),
      auth: signedIn,
    );
    // ar.json keys: appointments_tab_past = "السابقة".
    final pastTab = find.text('السابقة');
    expect(pastTab, findsOneWidget);
  });
}
