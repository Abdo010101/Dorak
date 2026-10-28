import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = Status.initial,
    this.user,
    this.phone = '',
    this.otp = '',
    this.errorMessage,
    this.otpSent = false,
    this.verified = false,
    this.loggedOut = false,
  });

  final Status status;
  final UserResponse? user;
  final String phone;
  final String otp;
  final String? errorMessage;
  final bool otpSent;
  final bool verified;
  final bool loggedOut;

  bool get isAuthenticated => user?.token != null;

  AuthState copyWith({
    Status? status,
    UserResponse? user,
    String? phone,
    String? otp,
    String? errorMessage,
    bool? otpSent,
    bool? verified,
    bool? loggedOut,
    bool clearError = false,
    bool clearUser = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: clearUser ? null : user ?? this.user,
        phone: phone ?? this.phone,
        otp: otp ?? this.otp,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        otpSent: otpSent ?? this.otpSent,
        verified: verified ?? this.verified,
        loggedOut: loggedOut ?? this.loggedOut,
      );

  @override
  List<Object?> get props =>
      [status, user, phone, otp, errorMessage, otpSent, verified, loggedOut];
}
