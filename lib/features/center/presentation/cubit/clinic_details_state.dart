import 'package:equatable/equatable.dart';

import '../../../../core/state/status.dart';
import '../../domain/entities/center_entity.dart';

class ClinicDetailsState extends Equatable {
  const ClinicDetailsState({
    this.status = Status.initial,
    this.clinic,
    this.errorMessage,
  });

  final Status status;
  final ClinicEntity? clinic;
  final String? errorMessage;

  ClinicDetailsState copyWith({
    Status? status,
    ClinicEntity? clinic,
    String? errorMessage,
    bool clearError = false,
  }) =>
      ClinicDetailsState(
        status: status ?? this.status,
        clinic: clinic ?? this.clinic,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, clinic, errorMessage];
}
