import 'package:equatable/equatable.dart';

import '../../../../core/state/status.dart';
import '../../domain/entities/center_entity.dart';

class CenterDetailsState extends Equatable {
  const CenterDetailsState({
    this.status = Status.initial,
    this.center,
    this.isFavorite = false,
    this.errorMessage,
  });

  final Status status;
  final CenterEntity? center;
  final bool isFavorite;
  final String? errorMessage;

  CenterDetailsState copyWith({
    Status? status,
    CenterEntity? center,
    bool? isFavorite,
    String? errorMessage,
    bool clearError = false,
  }) =>
      CenterDetailsState(
        status: status ?? this.status,
        center: center ?? this.center,
        isFavorite: isFavorite ?? this.isFavorite,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, center, isFavorite, errorMessage];
}
