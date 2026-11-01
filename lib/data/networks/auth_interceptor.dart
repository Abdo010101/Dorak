import 'package:dio/dio.dart';

import '../shared/shared_pref.dart';
import 'network_constant.dart';

/// Attaches `Authorization` + `Content-Language` on every outbound request
/// and triggers a logout callback on 401 so stale sessions self-heal.
///
/// Register BEFORE `LoggingInterceptor` so the logger prints the final
/// headers; register the pair in `InjectionClass.dio`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.prefs,
    required this.languageCode,
    this.onUnauthorized,
  });

  final SharedPref prefs;
  final String Function() languageCode;
  final Future<void> Function()? onUnauthorized;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getAccessToken();
    if (token.isNotEmpty) {
      options.headers[NetworkConstant.kAuthorizationHeader] = token;
    }
    options.headers[NetworkConstant.kLanguageHeader] = languageCode();
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      prefs.deleteLoginInfo();
      if (onUnauthorized != null) await onUnauthorized!();
    }
    handler.next(err);
  }
}
