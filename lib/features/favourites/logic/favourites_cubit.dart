import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import 'favourites_state.dart';

/// Phase 11 — Favourite centers feature. Repository is not wired yet (no
/// backend endpoint exists). Emits an empty list so the UI renders the
/// Figma empty state (Account 10, Figma `363:3887`). Swap `load()` for a
/// real `FavouritesRepository.list()` once the API lands.
class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit() : super(const FavouritesState());

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    await Future<void>.delayed(const Duration(milliseconds: 150));
    emit(state.copyWith(status: Status.success, items: const []));
  }

  void remove(int id) {
    final next = state.items.where((c) => c.id != id).toList(growable: false);
    emit(state.copyWith(items: next));
  }
}
