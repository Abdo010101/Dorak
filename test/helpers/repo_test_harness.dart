import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

/// Shared setup for every repository contract test.
///
/// Stubs the `connectivity_plus` method channel so `checkForConnectivity()`
/// returns `true` without hitting a platform host; exposes a `dioError`
/// builder that pins the backend error envelope to a JSON fixture.
///
/// Usage:
/// ```dart
/// void main() {
///   final harness = installRepoHarness();
///   test(...);
/// }
/// ```
RepoHarness installRepoHarness() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dev.fluttercommunity.plus/connectivity');
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'check') return 'wifi';
      return null;
    });
  });
  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
  return const RepoHarness();
}

class RepoHarness {
  const RepoHarness();

  DioException dioError({
    required int statusCode,
    required String fixturePath,
    String path = '/stub',
  }) {
    final req = RequestOptions(path: path);
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

  DioException timeout({String path = '/stub'}) => DioException(
        requestOptions: RequestOptions(path: path),
        type: DioExceptionType.connectionTimeout,
        message: 'connection timed out',
      );
}
