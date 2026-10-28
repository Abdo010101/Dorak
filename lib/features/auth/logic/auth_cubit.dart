import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import '../../../data/shared/shared_pref.dart';
import 'auth_state.dart';

/// Replaces `AuthController` + `LoginController` + `RegisterController` +
/// `VerifyController` for the phone+OTP flow Figma uses.
///
/// Shape mirrors `docs/feature_pattern_dorak.md`: emit effect flags
/// (`otpSent`, `verified`, `loggedOut`) that the UI listens on and acts
/// on (navigate, snackbar, etc.).
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthenticationRepository authenticationRepository,
    required SharedPref sharedPref,
  })  : _repo = authenticationRepository,
        _prefs = sharedPref,
        super(const AuthState());

  final AuthenticationRepository _repo;
  final SharedPref _prefs;

  void setPhone(String v) => emit(state.copyWith(phone: v, clearError: true));

  void setOtp(String v) => emit(state.copyWith(otp: v, clearError: true));

  Future<void> loadCurrentUser() async {
    if (!_prefs.isUserLoggedIn()) return;
    final stored = await _prefs.retrieveUserInfo();
    emit(state.copyWith(user: stored));
  }

  Future<void> sendOtp() async {
    emit(state.copyWith(
      status: Status.loading,
      otpSent: false,
      clearError: true,
    ));
    try {
      final result = await _repo.sendOtp(body: {'phone': state.phone});
      if (result.error == null) {
        emit(state.copyWith(status: Status.success, otpSent: true));
      } else {
        emit(state.copyWith(
          status: Status.failure,
          errorMessage: result.error?.message,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  Future<void> verifyOtp() async {
    emit(state.copyWith(
      status: Status.loading,
      verified: false,
      clearError: true,
    ));
    try {
      final result = await _repo.verifyOtp(body: {
        'phone': state.phone,
        'otp': state.otp,
      });
      if (result.error == null) {
        emit(state.copyWith(status: Status.success, verified: true));
      } else {
        emit(state.copyWith(
          status: Status.failure,
          errorMessage: result.error?.message,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      await _repo.logout();
      _prefs.deleteLoginInfo();
      emit(const AuthState(status: Status.success, loggedOut: true));
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }
}
