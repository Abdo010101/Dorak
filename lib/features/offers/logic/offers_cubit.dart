import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'offers_state.dart';

/// Replaces `OffersController`. Simpler surface: one page load, text search.
/// Pagination lands when a page reads `pagingController` from the Cubit.
class OffersCubit extends Cubit<OffersState> {
  OffersCubit({required OffersRepository offersRepository})
      : _repo = offersRepository,
        super(const OffersState());

  final OffersRepository _repo;

  Future<void> loadFirstPage() => _fetch(pageKey: 1, replace: true);

  void setQuery(String q) {
    emit(state.copyWith(query: q));
  }

  Future<void> search() => _fetch(pageKey: 1, replace: true);

  Future<void> _fetch({required int pageKey, required bool replace}) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getAllOffers(
        <String, dynamic>{'title': state.query},
        pageKey: pageKey,
      );
      final data = result.data;
      if (data != null) {
        final list = data.offers?.data ?? const [];
        emit(
          state.copyWith(
            status: Status.success,
            offers: replace ? list : [...state.offers, ...list],
            minPrice: data.minPrice,
            maxPrice: data.maxPrice,
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
