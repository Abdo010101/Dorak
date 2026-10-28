import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class PatientProfileState extends Equatable {
  const PatientProfileState({
    this.status = Status.initial,
    this.profile,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.gender,
    this.errorMessage,
    this.updated = false,
  });

  final Status status;
  final Patient? profile;
  final String name;
  final String phone;
  final String email;
  final String? gender;
  final String? errorMessage;
  final bool updated;

  PatientProfileState copyWith({
    Status? status,
    Patient? profile,
    String? name,
    String? phone,
    String? email,
    String? gender,
    String? errorMessage,
    bool? updated,
    bool clearError = false,
  }) =>
      PatientProfileState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        updated: updated ?? this.updated,
      );

  @override
  List<Object?> get props =>
      [status, profile, name, phone, email, gender, errorMessage, updated];
}
