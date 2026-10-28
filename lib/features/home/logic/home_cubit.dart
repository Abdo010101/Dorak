import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'home_state.dart';

/// Replaces the data surface of `HomeController`. Pagination for Best
/// Doctors stays in the UI layer with a `PagingController` until Phase 10.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required HomeRepository homeRepository})
      : _repo = homeRepository,
        super(const HomeState());

  final HomeRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getHomeData();
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            home: data,
            bestDoctors: data.bestDoctors ?? const [],
            latestOffers: data.latestOffers ?? const [],
            appointments: data.patientReservations ?? const [],
          ),
        );
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
