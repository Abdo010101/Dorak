import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'search_state.dart';

/// Replaces `SearchController` + `SearchResultController` + part of
/// `FilterController`. Owns query (debounced 350 ms), filter map, and
/// one page of results. Filter UI composition stays in the UI layer.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required DoctorsSearchResultRepository searchResultRepository,
    Duration debounce = const Duration(milliseconds: 350),
  })  : _repo = searchResultRepository,
        _debounce = debounce,
        super(const SearchState());

  final DoctorsSearchResultRepository _repo;
  final Duration _debounce;
  Timer? _debouncer;

  void setQuery(String q) {
    emit(state.copyWith(query: q));
    _debouncer?.cancel();
    _debouncer = Timer(_debounce, search);
  }

  void setFilter(String key, dynamic value) {
    final next = Map<String, dynamic>.from(state.filters);
    if (value == null) {
      next.remove(key);
    } else {
      next[key] = value;
    }
    emit(state.copyWith(filters: next));
  }

  void clearFilters() => emit(state.copyWith(filters: const {}));

  Future<void> search() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final params = <String, dynamic>{
        ...state.filters,
        if (state.query.isNotEmpty) 'name': state.query,
      };
      final result = await _repo.getDoctors(params, 1);
      final data = result.data;
      if (data != null) {
        emit(state.copyWith(status: Status.success, result: data));
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

  @override
  Future<void> close() {
    _debouncer?.cancel();
    return super.close();
  }
}
