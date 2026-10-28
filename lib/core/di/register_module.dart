import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart' show InjectionClass;
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Injectable module. Phase 4 scaffold — exposes shared singletons the
/// generated `injection.config.dart` wires into `getIt`.
///
/// Regenerate with `dart run build_runner build --delete-conflicting-outputs`
/// on a macOS/Linux host (Windows host blocked by missing
/// `frontend_server.dart.snapshot` in Flutter cache).
@module
abstract class RegisterModule {
  @singleton
  Dio get dio => InjectionClass.dio;

  @preResolve
  @singleton
  Future<SharedPref> get sharedPref => SharedPref.getInstance();

  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
