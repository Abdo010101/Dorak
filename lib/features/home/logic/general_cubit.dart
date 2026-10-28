import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';
import '../../../data/repository/repository.dart';
import 'general_state.dart';

/// Replaces `GeneralController`. Flutter-free below the data boundary;
/// navigation + location-permission effects stay in the UI layer and
/// hand the Cubit a `(lat, lng)` pair plus `isNavigate` separately.
class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit({required GeneralRepository generalRepository})
      : _repo = generalRepository,
        super(const GeneralState());

  final GeneralRepository _repo;

  Future<void> getGeneralData() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getGeneralData();
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            generalResponse: data,
            titles: List<Titles>.from(data.titles ?? const <Titles>[]),
            specializations: List<Titles>.from(
              data.mainSpecializations ?? const <Titles>[],
            ),
            originalAreas:
                List<Titles>.from(data.cities ?? const <Titles>[]),
            areas: List<Titles>.from(data.cities ?? const <Titles>[]),
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

  Future<void> getCities(int id) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getCityByArea(id);
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            originalCities: List<Titles>.from(data),
            cities: List<Titles>.from(data),
            areaId: id,
          ),
        );
      } else {
        emit(state.copyWith(status: Status.failure));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  Future<void> getSubSpeciality(int id) async {
    emit(
      state.copyWith(
        status: Status.loading,
        specializationId: id,
        specId: id,
        clearError: true,
      ),
    );
    try {
      final result = await _repo.getSubSpeciality(id);
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            originalSubSpecializations: List<Titles>.from(data),
            subSpecializations: List<Titles>.from(data),
          ),
        );
      } else {
        emit(state.copyWith(status: Status.failure));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  void searchSpecialization(String text) {
    final src = state.generalResponse?.mainSpecializations ?? const <Titles>[];
    if (text.isEmpty) {
      emit(state.copyWith(specializations: List<Titles>.from(src)));
      return;
    }
    final q = text.toLowerCase();
    emit(
      state.copyWith(
        specializations:
            src.where((e) => (e.name ?? '').toLowerCase().contains(q)).toList(),
      ),
    );
  }

  void searchSubSpecialization(String text) {
    if (text.isEmpty) {
      emit(
        state.copyWith(
          subSpecializations:
              List<Titles>.from(state.originalSubSpecializations),
        ),
      );
      return;
    }
    final q = text.toLowerCase();
    emit(
      state.copyWith(
        subSpecializations: state.originalSubSpecializations
            .where((e) => (e.name ?? '').toLowerCase().contains(q))
            .toList(),
      ),
    );
  }

  void searchArea(String text) {
    if (text.isEmpty) {
      emit(state.copyWith(areas: List<Titles>.from(state.originalAreas)));
      return;
    }
    final q = text.toLowerCase();
    emit(
      state.copyWith(
        areas: state.originalAreas
            .where((e) => (e.name ?? '').toLowerCase().contains(q))
            .toList(),
      ),
    );
  }

  void searchCity(String text) {
    if (text.isEmpty) {
      emit(state.copyWith(cities: List<Titles>.from(state.originalCities)));
      return;
    }
    final q = text.toLowerCase();
    emit(
      state.copyWith(
        cities: state.originalCities
            .where((e) => (e.name ?? '').toLowerCase().contains(q))
            .toList(),
      ),
    );
  }

  Future<void> searchByName(String name) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final params = <String, dynamic>{
        'name': name,
        'lat': state.lat,
        'lng': state.lng,
      };
      final result = await _repo.getSearchByName(params);
      final data = result.data;
      if (data != null) {
        emit(state.copyWith(status: Status.success, searchResult: data));
      } else {
        emit(state.copyWith(status: Status.failure));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  void onSpecializationChange(int id, String name) =>
      emit(state.copyWith(specializationId: id, specializationName: name));

  void onMainSpecializationChange(String name) => emit(
        state.copyWith(
          specializationId: state.specId,
          specializationName: name,
        ),
      );

  void onSelectedCity(int id) => emit(state.copyWith(cityId: id));

  void setMainSpecialization(bool value) =>
      emit(state.copyWith(isMainSpecialization: value));

  void setLatLng({required double lat, required double lng}) => emit(
        GeneralState(
          status: state.status,
          generalResponse: state.generalResponse,
          titles: state.titles,
          specializations: state.specializations,
          subSpecializations: state.subSpecializations,
          originalSubSpecializations: state.originalSubSpecializations,
          cities: state.cities,
          originalCities: state.originalCities,
          areas: state.areas,
          originalAreas: state.originalAreas,
          terms: state.terms,
          policy: state.policy,
          searchResult: state.searchResult,
          specId: state.specId,
          specializationId: state.specializationId,
          specializationName: state.specializationName,
          lat: lat,
          lng: lng,
          isMainSpecialization: state.isMainSpecialization,
        ),
      );

  Future<void> loadTermsAndPolicy() async {
    await _loadTerms();
    await _loadPolicy();
  }

  Future<void> _loadTerms() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getTermsAndService();
      if (result.data != null) {
        emit(state.copyWith(status: Status.success, terms: result.data));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }

  Future<void> _loadPolicy() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getPrivacyAndPolicy();
      if (result.data != null) {
        emit(state.copyWith(status: Status.success, policy: result.data));
      }
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }
}
