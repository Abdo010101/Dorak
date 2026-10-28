import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';

class AppReviewState extends Equatable {
  const AppReviewState({
    this.rating = 0,
    this.comment = '',
    this.status = Status.initial,
    this.errorMessage,
    this.submitted = false,
  });

  final double rating;
  final String comment;
  final Status status;
  final String? errorMessage;
  final bool submitted;

  AppReviewState copyWith({
    double? rating,
    String? comment,
    Status? status,
    String? errorMessage,
    bool? submitted,
    bool clearError = false,
  }) =>
      AppReviewState(
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        status: status ?? this.status,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        submitted: submitted ?? this.submitted,
      );

  @override
  List<Object?> get props =>
      [rating, comment, status, errorMessage, submitted];
}
