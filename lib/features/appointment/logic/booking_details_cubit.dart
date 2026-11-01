import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/appointment_response.dart';
import '../../../data/repository/appointment_repo.dart';
import '../../../data/repository/repository.dart';

/// Fetches a single reservation on open so the Booking Details screen
/// always shows the live backend state (scope answer §8.7). Falls back to
/// the reservation that was passed via router `extra` while the backend
/// detail call is unreachable.
class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  BookingDetailsCubit({required AppointmentsRepository repo})
      : _repo = repo,
        super(const BookingDetailsState());

  final AppointmentsRepository _repo;

  void seedFrom(AppointmentResponse? initial) {
    if (initial == null) return;
    emit(state.copyWith(reservation: initial));
  }

  Future<void> load(int id) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    final result = await _repo.getReservation(id);
    if (result.data != null) {
      emit(state.copyWith(
        status: Status.success,
        reservation: result.data,
      ));
    } else {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: result.error?.message,
      ));
    }
  }

  /// Optimistic update used after reschedule — writes the backend's new
  /// reservation (same id, back to `pending`) straight into state.
  void applyUpdated(AppointmentResponse updated) {
    emit(state.copyWith(reservation: updated));
  }
}

class BookingDetailsState {
  const BookingDetailsState({
    this.status = Status.initial,
    this.reservation,
    this.errorMessage,
  });

  final Status status;
  final AppointmentResponse? reservation;
  final String? errorMessage;

  BookingDetailsState copyWith({
    Status? status,
    AppointmentResponse? reservation,
    String? errorMessage,
    bool clearError = false,
  }) =>
      BookingDetailsState(
        status: status ?? this.status,
        reservation: reservation ?? this.reservation,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );
}
