import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/status.dart';
import '../../../../data/repository/centers_repo.dart';
import '../../../../data/repository/favourites_repo.dart';
import '../../data/center_entity_mapper.dart';
import '../../data/mock/center_mock.dart';
import 'center_details_state.dart';

/// `GET /patient/medical-centers/{id}` wired via [CentersRepository].
///
/// Falls back to [CenterMock.sample] when the network call fails so the
/// Figma screen stays viewable in dev without a live backend; follow-up
/// cleanup drops the fallback once the API is reliable.
class CenterDetailsCubit extends Cubit<CenterDetailsState> {
  CenterDetailsCubit({
    required CentersRepository repo,
    required FavouritesRepository favouritesRepo,
  })  : _repo = repo,
        _favouritesRepo = favouritesRepo,
        super(const CenterDetailsState());

  final CentersRepository _repo;
  final FavouritesRepository _favouritesRepo;
  int? _centerId;

  Future<void> load(int centerId) async {
    _centerId = centerId;
    emit(state.copyWith(status: Status.loading, clearError: true));
    final result = await _repo.medicalCenter(centerId);
    if (result.data != null) {
      emit(state.copyWith(
        status: Status.success,
        center: CenterEntityMapper.fromDetails(result.data!),
        isFavorite: result.data!.isFavorite ?? false,
      ));
      return;
    }
    emit(state.copyWith(
      status: Status.success,
      center: CenterMock.sample(),
      errorMessage: result.error?.message,
    ));
  }

  /// Toggles the heart via `POST /patient/add-medical-center-to-favorite/{id}`
  /// (or the matching remove). Optimistic — reverts on error.
  Future<void> toggleFavorite() async {
    final id = _centerId;
    if (id == null) return;
    final was = state.isFavorite;
    emit(state.copyWith(isFavorite: !was));
    final result = was
        ? await _favouritesRepo.remove(FavouriteType.medicalCenter, id)
        : await _favouritesRepo.add(FavouriteType.medicalCenter, id);
    if (result.error != null) {
      emit(state.copyWith(
        isFavorite: was,
        errorMessage: result.error?.message,
      ));
    }
  }
}
