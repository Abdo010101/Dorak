import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/status.dart';
import '../../../../data/repository/centers_repo.dart';
import '../../../../data/repository/favourites_repo.dart';
import '../../data/center_entity_mapper.dart';
import '../../data/mock/center_mock.dart';
import 'clinic_details_state.dart';

/// `GET /patient/clinics/{doctor_id}` wired via [CentersRepository].
///
/// Clinic favorites are stored on the backend as the clinic's doctor
/// (scope §9.4), so the heart toggles `add-doctor-to-favorite` / remove.
class ClinicDetailsCubit extends Cubit<ClinicDetailsState> {
  ClinicDetailsCubit({
    required CentersRepository repo,
    required FavouritesRepository favouritesRepo,
  })  : _repo = repo,
        _favouritesRepo = favouritesRepo,
        super(const ClinicDetailsState());

  final CentersRepository _repo;
  final FavouritesRepository _favouritesRepo;
  int? _doctorId;

  Future<void> load(int clinicId) async {
    _doctorId = clinicId;
    emit(state.copyWith(status: Status.loading, clearError: true));
    final result = await _repo.clinic(clinicId);
    if (result.data != null) {
      emit(state.copyWith(
        status: Status.success,
        clinic: CenterEntityMapper.clinicFromDetails(result.data!),
        isFavorite: result.data!.isFavorite ?? false,
      ));
      return;
    }
    emit(state.copyWith(
      status: Status.success,
      clinic: CenterMock.sampleClinic(),
      errorMessage: result.error?.message,
    ));
  }

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
}
