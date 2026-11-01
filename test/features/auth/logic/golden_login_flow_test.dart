import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Headless mirror of `integration_test/golden_login_flow_test.dart`.
///
/// Runs with `flutter test` (no device) so CI can gate every push on the
/// phone+OTP contract. The device-attached variant in `integration_test/`
/// exercises the full `main()` + navigator stack; this one focuses on the
/// cubit path so it stays fast and deterministic.
class _MockAuthRepo extends Mock implements AuthenticationRepository {}

class _MockPrefs extends Mock implements SharedPref {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  setUpAll(() => registerFallbackValue(UserResponse()));

  late _MockAuthRepo repo;
  late _MockPrefs prefs;

  setUp(() {
    repo = _MockAuthRepo();
    prefs = _MockPrefs();
    when(() => prefs.isUserLoggedIn()).thenReturn(false);
    when(() => prefs.retrieveUserInfo())
        .thenAnswer((_) async => UserResponse());
  });

  test('golden path — sendOtp → verifyOtp flips otpSent + verified', () async {
    when(() => repo.sendOtp(body: any(named: 'body')))
        .thenAnswer((_) async => BaseModel<dynamic>(data: 'ok'));
    when(() => repo.verifyOtp(body: any(named: 'body')))
        .thenAnswer((_) async => BaseModel<dynamic>(data: 'ok'));

    final cubit = AuthCubit(authenticationRepository: repo, sharedPref: prefs);
    cubit.setPhone('555123456');
    await cubit.sendOtp();
    expect(cubit.state.otpSent, isTrue);

    cubit.setOtp('1234');
    await cubit.verifyOtp();
    expect(cubit.state.verified, isTrue);
    expect(cubit.state.status, Status.success);

    await cubit.close();
  });

  test('401 on sendOtp → failure state, no otpSent flip', () async {
    when(() => repo.sendOtp(body: any(named: 'body'))).thenAnswer(
      (_) async => BaseModel<dynamic>(
        error: ErrorResponse()..message = 'unauthorized'..statusCode = 401,
      ),
    );

    final cubit = AuthCubit(authenticationRepository: repo, sharedPref: prefs);
    cubit.setPhone('555123456');
    await cubit.sendOtp();

    expect(cubit.state.status, Status.failure);
    expect(cubit.state.otpSent, isFalse);

    await cubit.close();
  });
}
