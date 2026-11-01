import 'package:dio/dio.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/data/networks/auth_interceptor.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockPrefs extends Mock implements SharedPref {}

/// Tests `AuthInterceptor` against a real `Dio` via a stub
/// `HttpClientAdapter` so the full interceptor chain runs: we assert the
/// outbound headers, and that a 401 fires `onUnauthorized` + the prefs purge.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    registerFallbackValue(UserResponse());
  });

  late _MockPrefs prefs;
  late Dio dio;
  late _StubAdapter adapter;
  int logoutCalls = 0;

  setUp(() {
    prefs = _MockPrefs();
    adapter = _StubAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://api.dorak.test/'))
      ..httpClientAdapter = adapter
      ..interceptors.add(AuthInterceptor(
        prefs: prefs,
        languageCode: () => 'ar',
        onUnauthorized: () async => logoutCalls++,
      ));
    logoutCalls = 0;
  });

  test('attaches Authorization + Content-Language when token present',
      () async {
    when(() => prefs.getAccessToken()).thenReturn('Bearer t.o.k.e.n');
    adapter.response = ResponseBody.fromString(
      '{"ok":true}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

    await dio.get<dynamic>('/ping');

    expect(adapter.lastHeaders['Authorization'], 'Bearer t.o.k.e.n');
    expect(adapter.lastHeaders['Content-Language'], 'ar');
  });

  test('omits Authorization when token empty', () async {
    when(() => prefs.getAccessToken()).thenReturn('');
    adapter.response = ResponseBody.fromString(
      '{"ok":true}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

    await dio.get<dynamic>('/ping');

    expect(adapter.lastHeaders.containsKey('Authorization'), isFalse);
    expect(adapter.lastHeaders['Content-Language'], 'ar');
  });

  test('401 — clears prefs and fires onUnauthorized', () async {
    when(() => prefs.getAccessToken()).thenReturn('Bearer stale');
    when(() => prefs.deleteLoginInfo()).thenAnswer((_) {});
    adapter.response = ResponseBody.fromString(
      '{"error":"unauthorized"}',
      401,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

    try {
      await dio.get<dynamic>('/protected');
    } on DioException catch (e) {
      expect(e.response?.statusCode, 401);
    }

    verify(() => prefs.deleteLoginInfo()).called(1);
    expect(logoutCalls, 1);
  });
}

/// Minimal `HttpClientAdapter` that records request headers and replies
/// with a canned `ResponseBody`.
class _StubAdapter implements HttpClientAdapter {
  Map<String, dynamic> lastHeaders = {};
  late ResponseBody response;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastHeaders = Map<String, dynamic>.from(options.headers);
    return response;
  }

  @override
  void close({bool force = false}) {}
}
