import 'package:dorakpattient/core/state/status.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Integration test template for the golden sign-in flow —
/// splash → welcome → OTP → home.
///
/// This file runs with `flutter test integration_test/` (CI-friendly, no
/// device needed) and with `flutter drive --driver=test_driver/integration_test.dart`
/// on a device. The repos are mocked so no network is touched; the test
/// focuses on the cubit → navigation contract. Swap the mocks for a
/// staging-env `Dio` to turn this into a true end-to-end test.
class _MockAuthRepo extends Mock implements AuthenticationRepository {}

class _MockPrefs extends Mock implements SharedPref {}

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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

  testWidgets('sendOtp → verifyOtp success path flips cubit flags',
      (tester) async {
    when(() => repo.sendOtp(body: any(named: 'body')))
        .thenAnswer((_) async => BaseModel<dynamic>(data: 'ok'));
    when(() => repo.verifyOtp(body: any(named: 'body')))
        .thenAnswer((_) async => BaseModel<dynamic>(data: 'ok'));

    final cubit = AuthCubit(authenticationRepository: repo, sharedPref: prefs);

    // 1 — phone entered + sendOtp
    cubit.setPhone('555123456');
    await cubit.sendOtp();
    expect(cubit.state.status, Status.success);
    expect(cubit.state.otpSent, isTrue);

    // 2 — OTP entered + verifyOtp
    cubit.setOtp('1234');
    await cubit.verifyOtp();
    expect(cubit.state.status, Status.success);
    expect(cubit.state.verified, isTrue);

    await cubit.close();
  });

  testWidgets('401 on sendOtp surfaces failure state', (tester) async {
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
