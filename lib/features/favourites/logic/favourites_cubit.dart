import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/favourites_repo.dart';
import 'favourites_state.dart';

/// Lists the signed-in patient's favorite medical centers via
/// `GET /patient/favorites?type=medical_center` (scope §10.2).
///
/// The toggle actions (add/remove) live where the heart affordance is — on
/// center/clinic/doctor/offer detail pages — and call
/// [FavouritesRepository] directly from those cubits.
class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit({required FavouritesRepository repo})
      : _repo = repo,
        super(const FavouritesState());

  final FavouritesRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    final result = await _repo.list(FavouriteType.medicalCenter);
    if (result.error != null) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: result.error?.message,
      ));
      return;
    }
    final items = (result.data ?? const [])
        .map((f) => FavouriteCenter(
              id: f.id ?? 0,
              name: f.name ?? '',
              imageUrl: f.image,
              distance: f.distanceKm != null
                  ? '${f.distanceKm!.toStringAsFixed(1)} km'
                  : null,
              rating: double.tryParse(f.rating ?? ''),
            ))
        .toList(growable: false);
    emit(state.copyWith(status: Status.success, items: items));
  }

  Future<void> remove(int id) async {
    final result = await _repo.remove(FavouriteType.medicalCenter, id);
    if (result.error != null) {
      emit(state.copyWith(errorMessage: result.error?.message));
      return;
    }
    final next = state.items.where((c) => c.id != id).toList(growable: false);
    emit(state.copyWith(items: next));
  }
}
