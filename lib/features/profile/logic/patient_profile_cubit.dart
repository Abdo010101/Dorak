import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';
import '../../../data/repository/repository.dart';
import 'patient_profile_state.dart';

/// Replaces `PatientProfileController`. Navigation + legacy
/// `AuthController` side-effect of writing `currentUser.patient` happen
/// in the UI listener on `state.updated`.
class PatientProfileCubit extends Cubit<PatientProfileState> {
  PatientProfileCubit({required ProfileRepository profileRepository})
      : _repo = profileRepository,
        super(const PatientProfileState());

  final ProfileRepository _repo;

  void seedFrom(Patient? patient) {
    emit(
      state.copyWith(
        profile: patient,
        name: patient?.name ?? '',
        phone: patient?.phone ?? '',
        email: patient?.email ?? '',
        gender: patient?.gender,
      ),
    );
  }

  void setName(String v) => emit(state.copyWith(name: v));
  void setPhone(String v) => emit(state.copyWith(phone: v));
  void setEmail(String v) => emit(state.copyWith(email: v));
  void setGender(String v) => emit(state.copyWith(gender: v));

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getProfileData();
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            profile: data,
            name: data.name ?? '',
            phone: data.phone ?? '',
            email: data.email ?? '',
            gender: data.gender,
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

  Future<void> update() async {
    emit(state.copyWith(status: Status.loading, clearError: true, updated: false));
    final patch = Patient(
      name: state.name,
      phone: state.phone,
      email: state.email,
      gender: state.gender,
    );
    try {
      final result = await _repo.updateProfile(patch);
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            profile: data,
            updated: true,
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
