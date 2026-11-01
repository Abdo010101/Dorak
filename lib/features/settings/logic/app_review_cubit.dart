import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'app_review_state.dart';

/// Submits an **app** rating via `POST /patient/app-ratings`. Doctor ratings
/// use `RateRepository.doctorRate` and live in the booking rate sheet.
class AppReviewCubit extends Cubit<AppReviewState> {
  AppReviewCubit({required RateRepository rateRepository})
      : _rateRepository = rateRepository,
        super(const AppReviewState());

  final RateRepository _rateRepository;

  void setRating(double value) => emit(state.copyWith(rating: value));

  void setComment(String value) => emit(state.copyWith(comment: value));

  void reset() => emit(const AppReviewState());

  Future<void> submit() async {
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
      final body = <String, dynamic>{
        'rate': state.rating.toInt(),
        if (state.comment.trim().isNotEmpty) 'comment': state.comment,
      };
      final result = await _rateRepository.appRate(body);
      if (result.error == null) {
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
