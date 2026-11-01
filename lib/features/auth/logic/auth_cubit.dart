import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';
import '../../../data/repository/repository.dart';
import '../../../data/shared/shared_pref.dart';
import 'auth_state.dart';

/// Replaces `AuthController` + `LoginController` + `RegisterController` +
/// `VerifyController` for the phone+OTP flow Figma uses.
///
/// Shape mirrors `docs/feature_pattern_dorak.md`: emit effect flags
/// (`otpSent`, `verified`, `needsProfile`, `profileCompleted`, `loggedOut`)
/// that the UI listens on and acts on (navigate, snackbar, etc.).
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

  void setName(String v) => emit(state.copyWith(name: v, clearError: true));

  void setEmail(String v) => emit(state.copyWith(email: v, clearError: true));

  void resetFlags() => emit(state.copyWith(
        otpSent: false,
        verified: false,
        needsProfile: false,
        profileCompleted: false,
        loggedOut: false,
        clearError: true,
      ));

  Future<void> loadCurrentUser() async {
    if (!_prefs.isUserLoggedIn()) return;
    final stored = await _prefs.retrieveUserInfo();
    emit(state.copyWith(user: stored));
  }

  Future<void> sendOtp() async {
    if (!_isValidPhone(state.phone)) {
      emit(state.copyWith(
        status: Status.failure,
        otpSent: false,
        errorMessage: 'phone_invalid_error',
      ));
      return;
    }
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
    if (state.otp.length < 4) {
      emit(state.copyWith(
        status: Status.failure,
        verified: false,
        errorMessage: 'otp_invalid_error',
      ));
      return;
    }
    emit(state.copyWith(
      status: Status.loading,
      verified: false,
      clearError: true,
    ));
    try {
      // Sign-in OTP verification lives on `POST /patient/check-otp` (scope
      // §10.1.2). The authenticated `/patient/verify` endpoint returns 401
      // until the patient already holds a Bearer token.
      final result = await _repo.checkOtp(body: {
        'phone': state.phone,
        'otp': state.otp,
      });
      if (result.error != null) {
        emit(state.copyWith(
          status: Status.failure,
          verified: false,
          errorMessage: result.error?.message ?? 'otp_invalid_error',
        ));
        return;
      }
      // Backend envelope is `{success, data:{token, is_new_user,
      // profile_completed, patient}, message}`.
      final raw = result.data;
      Map<String, dynamic> payload = const {};
      if (raw is Map && raw['data'] is Map) {
        payload = Map<String, dynamic>.from(raw['data'] as Map);
      } else if (raw is Map<String, dynamic>) {
        payload = raw;
      }
      final user = UserResponse.fromJson(payload);
      if ((user.token ?? '').isEmpty) {
        emit(state.copyWith(
          status: Status.failure,
          verified: false,
          errorMessage: 'otp_invalid_error',
        ));
        return;
      }
      await _prefs.storeLoginInfo(user);
      final patient = user.patient;
      final needsProfile = (user.profileCompleted == false) ||
          patient?.name == null ||
          patient!.name!.trim().isEmpty;
      emit(state.copyWith(
        status: Status.success,
        verified: true,
        user: user,
        needsProfile: needsProfile,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  Future<void> completeProfile() async {
    if (state.name.trim().isEmpty || !_isValidEmail(state.email)) {
      emit(state.copyWith(
        status: Status.failure,
        profileCompleted: false,
        errorMessage: 'required',
      ));
      return;
    }
    emit(state.copyWith(
      status: Status.loading,
      profileCompleted: false,
      clearError: true,
    ));
    try {
      final result = await _repo.completeData(body: {
        'name': state.name,
        'email': state.email,
        'phone': state.phone,
      });
      if (result.error == null) {
        emit(state.copyWith(
          status: Status.success,
          profileCompleted: true,
          needsProfile: false,
        ));
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

  /// `POST /patient/delete-account` (scope §10.2). Backend cancels any
  /// upcoming reservations, revokes the token, and soft-deletes the
  /// patient — mobile mirrors `logout()`'s cleanup afterwards.
  Future<void> deleteAccount() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.deleteAccount();
      if (result.error != null) {
        emit(state.copyWith(
          status: Status.failure,
          errorMessage: result.error?.message,
        ));
        return;
      }
      _prefs.deleteLoginInfo();
      emit(const AuthState(status: Status.success, loggedOut: true));
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  /// `POST /patient/resend-otp` (scope §10.2). Called from `otp_page.dart`
  /// after the 45 s cooldown. Backend throttles: 3/account + 20/IP per 10 min.
  Future<void> resendOtp() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.resendOtp();
      if (result.error != null) {
        emit(state.copyWith(
          status: Status.failure,
          errorMessage: result.error?.message,
        ));
        return;
      }
      emit(state.copyWith(status: Status.success, otpSent: true));
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  bool _isValidPhone(String v) {
    final digits = v.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 9 && digits.length <= 10;
  }

  bool _isValidEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
}
