import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/discovery_repo.dart';
import 'search_state.dart';

/// `GET /patient/search?search&lat&lng&specialization_id&per_page`
/// (scope §10.1.4). Returns specializations + medical_centers + clinics
/// in one call. Debounces the query 350 ms.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required DiscoveryRepository discoveryRepository,
    Duration debounce = const Duration(milliseconds: 350),
  })  : _repo = discoveryRepository,
        _debounce = debounce,
        super(const SearchState());

  final DiscoveryRepository _repo;
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
    if (state.query.trim().isEmpty) return;
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.search(
        search: state.query,
        lat: state.filters['lat'] as double?,
        lng: state.filters['lng'] as double?,
        specializationId: state.filters['specialization_id'] as int?,
        perPage: state.filters['per_page'] as int?,
      );
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
