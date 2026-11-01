import 'dart:convert';
import 'dart:io';

/// Reads a JSON fixture under `test/fixtures/` and returns it as a `Map`.
///
/// Fixtures pin the real backend contract per endpoint. If the API shape
/// drifts, the fixture update + repository test failure are the regression
/// signal — not a crash in production.
///
/// Example:
/// ```dart
/// final json = jsonFixture('auth/send_otp_success.json');
/// ```
Map<String, dynamic> jsonFixture(String path) {
  final raw = File('test/fixtures/$path').readAsStringSync();
  return jsonDecode(raw) as Map<String, dynamic>;
}

String rawFixture(String path) =>
    File('test/fixtures/$path').readAsStringSync();
