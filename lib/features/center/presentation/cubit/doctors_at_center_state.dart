import 'package:equatable/equatable.dart';

import '../../../../core/state/status.dart';
import '../../domain/entities/center_entity.dart';

class DoctorsAtCenterState extends Equatable {
  const DoctorsAtCenterState({
    this.status = Status.initial,
    this.center,
    this.selectedSpecialty = 'all',
    this.errorMessage,
  });

  final Status status;
  final CenterEntity? center;
  final String selectedSpecialty;
  final String? errorMessage;

  List<DoctorAtCenter> get filteredDoctors {
    final all = center?.doctors ?? const [];
    if (selectedSpecialty == 'all') return all;
    return all.where((d) => d.specialtyKey == selectedSpecialty).toList();
  }

  DoctorsAtCenterState copyWith({
    Status? status,
    CenterEntity? center,
    String? selectedSpecialty,
    String? errorMessage,
    bool clearError = false,
  }) =>
      DoctorsAtCenterState(
        status: status ?? this.status,
        center: center ?? this.center,
        selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, center, selectedSpecialty, errorMessage];
}
