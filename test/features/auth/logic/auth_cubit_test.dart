import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthenticationRepository {}

class _MockSharedPref extends Mock implements SharedPref {}

void main() {
  late _MockAuthRepo repo;
  late _MockSharedPref prefs;

  setUpAll(() {
    registerFallbackValue(UserResponse());
  });

  setUp(() {
    repo = _MockAuthRepo();
    prefs = _MockSharedPref();
  });

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'setPhone emits new phone',
      build: () =>
          AuthCubit(authenticationRepository: repo, sharedPref: prefs),
      act: (c) => c.setPhone('0555'),
      expect: () => const [AuthState(phone: '0555')],
    );

    blocTest<AuthCubit, AuthState>(
      'sendOtp success flips otpSent flag',
      setUp: () {
        when(() => repo.sendOtp(body: any(named: 'body')))
            .thenAnswer((_) async => BaseModel<dynamic>(data: 'ok'));
      },
      build: () =>
          AuthCubit(authenticationRepository: repo, sharedPref: prefs),
      seed: () => const AuthState(phone: '555123456'),
      act: (c) => c.sendOtp(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.otpSent, isTrue);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'verifyOtp success flips verified flag',
      setUp: () {
        when(() => repo.checkOtp(body: any(named: 'body'))).thenAnswer(
          (_) async => BaseModel<dynamic>(data: {
            'data': {
              'token': 'Bearer t.o.k.e.n',
              'profile_completed': true,
              'patient': {'id': 1, 'name': 'أحمد', 'phone': '0555'},
            },
          }),
        );
        when(() => prefs.storeLoginInfo(any()))
            .thenAnswer((_) async => true);
      },
      build: () =>
          AuthCubit(authenticationRepository: repo, sharedPref: prefs),
      seed: () => const AuthState(phone: '0555', otp: '1234'),
      act: (c) => c.verifyOtp(),
      verify: (c) {
        expect(c.state.status, Status.success);
        expect(c.state.verified, isTrue);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'verifyOtp success persists token via prefs.storeLoginInfo',
      setUp: () {
        when(() => repo.checkOtp(body: any(named: 'body'))).thenAnswer(
          (_) async => BaseModel<dynamic>(data: {
            'data': {
              'token': 'Bearer t.o.k.e.n',
              'profile_completed': true,
              'patient': {'id': 42, 'name': 'أحمد', 'phone': '555123456'},
            },
          }),
        );
        when(() => prefs.storeLoginInfo(any()))
            .thenAnswer((_) async => true);
      },
      build: () =>
          AuthCubit(authenticationRepository: repo, sharedPref: prefs),
      seed: () => const AuthState(phone: '555123456', otp: '1234'),
      act: (c) => c.verifyOtp(),
      verify: (c) {
        expect(c.state.verified, isTrue);
        expect(c.state.user?.patient?.id, 42);
        expect(c.state.needsProfile, isFalse);
        verify(() => prefs.storeLoginInfo(any())).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'logout clears user and flips loggedOut',
      setUp: () {
        when(() => repo.logout())
            .thenAnswer((_) async => BaseModel<dynamic>(data: 'ok'));
        when(() => prefs.deleteLoginInfo()).thenReturn(null);
      },
      build: () =>
          AuthCubit(authenticationRepository: repo, sharedPref: prefs),
      seed: () => const AuthState(user: null),
      act: (c) => c.logout(),
      verify: (c) {
        expect(c.state.loggedOut, isTrue);
        expect(c.state.user, isNull);
      },
    );
  });
}
