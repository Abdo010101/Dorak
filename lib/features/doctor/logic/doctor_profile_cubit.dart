import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'doctor_profile_state.dart';

/// Replaces `DoctorProfileController`. Pure data; UI picks tab/place.
class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  DoctorProfileCubit({
    required DoctorProfileRepository doctorProfileRepository,
  })  : _repo = doctorProfileRepository,
        super(const DoctorProfileState());

  final DoctorProfileRepository _repo;

  Future<void> load(int doctorId) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getDoctorProfile(doctorId: doctorId);
      final data = result.data;
      if (data != null) {
        final hasPlaces =
            data.places != null && data.places!.isNotEmpty;
        emit(
          state.copyWith(
            status: Status.success,
            profile: data,
            selectedPlaceIndex: hasPlaces ? 0 : null,
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

  void selectPlace(int index) =>
      emit(state.copyWith(selectedPlaceIndex: index));

  void setTab(DoctorProfileTab tab) => emit(state.copyWith(tab: tab));

  void reset() => emit(const DoctorProfileState());
}
