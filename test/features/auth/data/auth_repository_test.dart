import 'package:dio/dio.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/clients/clients.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class _MockAuthClient extends Mock implements AuthenticationClient {}

/// Contract-driven tests for `AuthenticationRepository`.
///
/// Each test pins the backend response shape via a JSON fixture under
/// `test/fixtures/auth/`. If the backend shape drifts the fixture update
/// is the explicit edit — the test red here is the regression signal.
///
/// The 401/422 cases build real `DioException`s so `ErrorResponse`'s
/// parsing (`response.data['errors']` → `message`) is exercised end-to-end.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // `BaseRepository.checkForConnectivity()` hits the connectivity_plus
  // platform channel. In widget-test mode there is no plugin host, so we
  // stub the channel to always report "wifi" (= online) and move on.
  const connectivityChannel =
      MethodChannel('dev.fluttercommunity.plus/connectivity');
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, (call) async {
      if (call.method == 'check') return 'wifi';
      return null;
    });
  });
  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, null);
  });

  late _MockAuthClient client;
  late AuthenticationRepository repo;

  setUp(() {
    client = _MockAuthClient();
    repo = AuthenticationRepository(authenticationClient: client);
  });

  /// Builds a Dio-style error whose `response.data` matches `fixturePath`,
  /// so `ErrorResponse` can parse the real backend error envelope.
  DioException buildDioError({
    required int statusCode,
    required String fixturePath,
  }) {
    final req = RequestOptions(path: '/auth/stub');
    return DioException(
      requestOptions: req,
      response: Response(
        requestOptions: req,
        statusCode: statusCode,
        data: jsonFixture(fixturePath),
      ),
      type: DioExceptionType.badResponse,
    );
  }

  group('sendOtp', () {
    test('success — returns BaseModel with no error', () async {
      when(() => client.sendOtp(any()))
          .thenAnswer((_) async => jsonFixture('auth/send_otp_success.json'));

      final result = await repo.sendOtp(body: {'phone': '555123456'});

      expect(result.error, isNull);
      expect(result.data, isNotNull);
      expect((result.data as Map)['message'], 'OTP sent');
      verify(() => client.sendOtp({'phone': '555123456'})).called(1);
    });

    test('422 — maps validation error to ErrorResponse.message', () async {
      when(() => client.sendOtp(any())).thenThrow(
        buildDioError(statusCode: 422, fixturePath: 'auth/send_otp_422.json'),
      );

      final result = await repo.sendOtp(body: {'phone': 'bad'});

      expect(result.data, isNull);
      expect(result.error, isNotNull);
      expect(result.error!.statusCode, 422);
      expect(result.error!.message, 'رقم الجوال غير صحيح');
    });
  });

  group('verifyOtp', () {
    test('success — returns token + patient fixture', () async {
      final fx = jsonFixture('auth/verify_otp_success.json');
      when(() => client.verifyOtp(any())).thenAnswer((_) async => fx);

      final result = await repo.verifyOtp(
        body: {'phone': '555123456', 'otp': '1234'},
      );

      expect(result.error, isNull);
      final data = result.data as Map<String, dynamic>;
      expect(data['token'], startsWith('eyJ'));
      expect(data['profile_completed'], true);
      expect((data['patient'] as Map)['id'], 42);
    });

    test('401 — maps to ErrorResponse with statusCode 401', () async {
      when(() => client.verifyOtp(any())).thenThrow(
        buildDioError(statusCode: 401, fixturePath: 'auth/verify_otp_401.json'),
      );

      final result = await repo.verifyOtp(
        body: {'phone': '555123456', 'otp': '9999'},
      );

      expect(result.error, isNotNull);
      expect(result.error!.statusCode, 401);
      expect(result.error!.message, 'رمز التحقق غير صحيح');
    });
  });

  group('completeData', () {
    test('success — parses Patient from BaseResponse envelope', () async {
      final fx = jsonFixture('auth/complete_data_success.json');
      final envelope = BaseResponse<Patient>(
        data: Patient.fromJson(fx['data'] as Map<String, dynamic>),
      );
      when(() => client.completeData(any()))
          .thenAnswer((_) async => envelope);

      final result = await repo.completeData(body: {
        'name': 'أحمد المريض',
        'email': 'ahmed@example.com',
        'phone': '555123456',
      });

      expect(result.error, isNull);
      expect(result.data, isA<Patient>());
      expect(result.data!.id, 42);
      expect(result.data!.email, 'ahmed@example.com');
    });
  });

  group('logout', () {
    test('success — returns BaseModel with no error', () async {
      when(() => client.logout())
          .thenAnswer((_) async => jsonFixture('auth/logout_success.json'));

      final result = await repo.logout();

      expect(result.error, isNull);
      expect((result.data as Map)['message'], 'logged out');
      verify(() => client.logout()).called(1);
    });

    test('network error — surfaces DioException.message', () async {
      final req = RequestOptions(path: '/auth/logout');
      when(() => client.logout()).thenThrow(DioException(
        requestOptions: req,
        type: DioExceptionType.connectionTimeout,
        message: 'connection timed out',
      ));

      final result = await repo.logout();

      expect(result.error, isNotNull);
      expect(result.error!.dioError, isA<DioException>());
    });
  });
}
