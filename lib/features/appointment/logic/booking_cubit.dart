import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';
import '../../../data/repository/repository.dart';
import 'booking_state.dart';

/// Replaces `ReservationAppointmentController` + `ManualAppointmentController`.
/// Pure data; `EasyLoading` + post-confirm effects stay in UI listener on
/// `state.booked` and `state.status`.
class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required AvailableAppointmentRepository availableAppointmentRepository,
  })  : _repo = availableAppointmentRepository,
        super(const BookingState());

  final AvailableAppointmentRepository _repo;

  void setDoctor(int doctorId) =>
      emit(state.copyWith(doctorId: doctorId, clearError: true));

  void setPlace(int? placeId) =>
      emit(state.copyWith(placeId: placeId, clearError: true));

  void selectDay(Week day) => emit(state.copyWith(selectedDay: day));

  void selectTime(String time) => emit(state.copyWith(selectedTime: time));

  Future<void> loadSchedules() async {
    final doctorId = state.doctorId;
    if (doctorId == null) return;
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getAvailableSchedules(
        id: state.placeId,
        doctorId: doctorId,
      );
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            schedules: data.schedules ?? const [],
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

  Future<void> confirm() async {
    if (!state.canConfirm) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: 'select_day_and_time',
      ));
      return;
    }
    emit(state.copyWith(
      status: Status.loading,
      booked: false,
      clearError: true,
    ));
    try {
      final result = await _repo.makeReservations(
        data: {
          'medical_center_id':
              state.placeId == 0 ? '' : state.placeId,
          'doctor_id': state.doctorId,
          'date': state.selectedDay?.date,
          'time': state.selectedTime,
          'day_of_week': state.selectedDay?.name,
        },
      );
      if (result.data != null) {
        emit(state.copyWith(status: Status.success, booked: true));
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

  void reset() => emit(const BookingState());
}
