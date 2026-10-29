import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class AuthState extends Equatable {
  const AuthState({
    this.status = Status.initial,
    this.user,
    this.phone = '',
    this.otp = '',
    this.name = '',
    this.email = '',
    this.errorMessage,
    this.otpSent = false,
    this.verified = false,
    this.needsProfile = false,
    this.profileCompleted = false,
    this.loggedOut = false,
  });

  final Status status;
  final UserResponse? user;
  final String phone;
  final String otp;
  final String name;
  final String email;
  final String? errorMessage;
  final bool otpSent;
  final bool verified;
  final bool needsProfile;
  final bool profileCompleted;
  final bool loggedOut;

  bool get isAuthenticated => user?.token != null;

  AuthState copyWith({
    Status? status,
    UserResponse? user,
    String? phone,
    String? otp,
    String? name,
    String? email,
    String? errorMessage,
    bool? otpSent,
    bool? verified,
    bool? needsProfile,
    bool? profileCompleted,
    bool? loggedOut,
    bool clearError = false,
    bool clearUser = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: clearUser ? null : user ?? this.user,
        phone: phone ?? this.phone,
        otp: otp ?? this.otp,
        name: name ?? this.name,
        email: email ?? this.email,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        otpSent: otpSent ?? this.otpSent,
        verified: verified ?? this.verified,
        needsProfile: needsProfile ?? this.needsProfile,
        profileCompleted: profileCompleted ?? this.profileCompleted,
        loggedOut: loggedOut ?? this.loggedOut,
      );

  @override
  List<Object?> get props => [
        status,
        user,
        phone,
        otp,
        name,
        email,
        errorMessage,
        otpSent,
        verified,
        needsProfile,
        profileCompleted,
        loggedOut,
      ];
}
