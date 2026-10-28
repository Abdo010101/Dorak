import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/request/rate_request.dart';
import '../../../data/repository/repository.dart';
import 'app_review_state.dart';

/// Replaces `AppReviewController`. Pure data in/out; navigation on success
/// is the caller's responsibility (listen on `state.submitted`).
class AppReviewCubit extends Cubit<AppReviewState> {
  AppReviewCubit({required RateRepository rateRepository})
      : _rateRepository = rateRepository,
        super(const AppReviewState());

  final RateRepository _rateRepository;

  void setRating(double value) => emit(state.copyWith(rating: value));

  void setComment(String value) => emit(state.copyWith(comment: value));

  void reset() => emit(const AppReviewState());

  Future<void> submit({int? doctorId}) async {
    if (state.rating == 0) {
      emit(
        state.copyWith(
          status: Status.failure,
          errorMessage: 'rating_required',
        ),
      );
      return;
    }
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _rateRepository.doctorRate(
        RateRequest(
          comment: state.comment,
          rate: state.rating.toInt(),
          doctorId: doctorId,
        ),
      );
      if (result.data != null) {
        emit(state.copyWith(status: Status.success, submitted: true));
      } else {
        emit(
          state.copyWith(
            status: Status.failure,
            errorMessage: result.error?.message,
          ),
        );
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }
}
