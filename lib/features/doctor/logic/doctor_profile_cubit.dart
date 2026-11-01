import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/favourites_repo.dart';
import '../../../data/repository/repository.dart';
import 'doctor_profile_state.dart';

/// Replaces `DoctorProfileController`. Loads `GET /patient/doctors/{id}`
/// (scope §10.1.26), seeds the `is_favorite` flag from `profile.is_favorite`,
/// and owns the heart toggle via [FavouritesRepository] (scope §10.2).
class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  DoctorProfileCubit({
    required DoctorProfileRepository doctorProfileRepository,
    required FavouritesRepository favouritesRepository,
  })  : _repo = doctorProfileRepository,
        _favouritesRepo = favouritesRepository,
        super(const DoctorProfileState());

  final DoctorProfileRepository _repo;
  final FavouritesRepository _favouritesRepo;
  int? _doctorId;

  Future<void> load(int doctorId) async {
    _doctorId = doctorId;
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getDoctorProfile(doctorId: doctorId);
      final data = result.data;
      if (data != null) {
        final hasPlaces = data.places != null && data.places!.isNotEmpty;
        emit(
          state.copyWith(
            status: Status.success,
            profile: data,
            selectedPlaceIndex: hasPlaces ? 0 : null,
            isFavorite: data.profile?.isFavorite ?? false,
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

  Future<void> loadOffers(int doctorId) async {
    try {
      final result = await _repo.getDoctorOffers(doctorId: doctorId);
      final data = result.data;
      if (data != null) emit(state.copyWith(offers: data));
    } on DioException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }

  /// Optimistic add/remove via `POST /patient/add-doctor-to-favorite/{id}`
  /// (or the matching remove). Reverts on error.
  Future<void> toggleFavorite() async {
    final id = _doctorId;
    if (id == null) return;
    final was = state.isFavorite;
    emit(state.copyWith(isFavorite: !was));
    final result = was
        ? await _favouritesRepo.remove(FavouriteType.doctor, id)
        : await _favouritesRepo.add(FavouriteType.doctor, id);
    if (result.error != null) {
      emit(state.copyWith(
        isFavorite: was,
        errorMessage: result.error?.message,
      ));
    }
  }

  void selectPlace(int index) =>
      emit(state.copyWith(selectedPlaceIndex: index));

  void setTab(DoctorProfileTab tab) => emit(state.copyWith(tab: tab));

  void reset() => emit(const DoctorProfileState());
}
