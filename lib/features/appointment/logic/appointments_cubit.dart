import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'appointments_state.dart';

/// Replaces `AppointmentsController`. Legacy `pagingController` + Easy
/// loader stay in the UI layer; this Cubit owns the data list only.
class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit({
    required AppointmentsRepository appointmentsRepository,
  })  : _repo = appointmentsRepository,
        super(const AppointmentsState());

  final AppointmentsRepository _repo;

  void setTab(AppointmentsTab next) {
    if (next == state.tab) return;
    emit(state.copyWith(tab: next));
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getAllAppointments(
        'reservations/${state.tab.name}',
        pageKey: 1,
      );
      final data = result.data;
      if (data != null) {
        emit(state.copyWith(status: Status.success, items: data));
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

  Future<void> cancel(int index) async {
    if (index < 0 || index >= state.items.length) return;
    final target = state.items[index];
    try {
      final result = await _repo.declineAppointment({'id': target.id});
      if (result.data != null) {
        final next = [...state.items];
        next[index].status = 'cancelled';
        emit(state.copyWith(items: next));
      }
    } on DioException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }
}
