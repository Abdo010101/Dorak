import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/booking_response.dart';
import '../../../data/repository/booking_repo.dart';
import 'booking_state.dart';

/// Drives the 4-step booking stepper (scope §9.3 / §9.4).
///
///   step 1: specialty / doctor (UI only — writes [state.doctorId],
///           optionally [state.specializationId] for "any doctor" at a center)
///   step 2: `GET /patient/booking/days` → `GET /patient/booking/slots`
///   step 3: `POST /patient/booking/preview` → shows review
///   step 4: `POST /patient/reservations` → confirmed screen
///
/// Clinic vs center: pass [BookingVariant.clinic] in [start] and omit the
/// medical_center_id on every call (backend treats null as the doctor's own
/// clinic). A 422 `errors.doctor_id` means that doctor only works at
/// centers — surface the backend message as-is.
class BookingCubit extends Cubit<BookingState> {
  BookingCubit({required BookingRepository bookingRepository})
      : _booking = bookingRepository,
        super(const BookingState());

  final BookingRepository _booking;

  /// Open the stepper for a specific target. Resets everything else.
  void start({
    required BookingVariant variant,
    required int doctorId,
    int? medicalCenterId,
    int? specializationId,
  }) {
    emit(BookingState(
      variant: variant,
      doctorId: doctorId,
      medicalCenterId:
          variant == BookingVariant.clinic ? null : medicalCenterId,
      specializationId: specializationId,
    ));
  }

  void setDoctor(int doctorId) =>
      emit(state.copyWith(doctorId: doctorId, clearError: true));

  void setSpecialization(int? specializationId) =>
      emit(state.copyWith(specializationId: specializationId, clearError: true));

  void setNote(String? note) => emit(state.copyWith(note: note));

  Future<void> loadDays() async {
    emit(state.copyWith(daysStatus: Status.loading, clearError: true));
    final result = await _booking.days(
      doctorId: state.doctorId,
      medicalCenterId: state.medicalCenterId,
      specializationId: state.specializationId,
    );
    if (result.data != null) {
      emit(state.copyWith(daysStatus: Status.success, days: result.data!));
    } else {
      emit(state.copyWith(
        daysStatus: Status.failure,
        errorMessage: result.error?.message,
      ));
    }
  }

  Future<void> selectDay(BookingDay day) async {
    emit(state.copyWith(
      selectedDay: day,
      clearSelectedSlot: true,
      slotsStatus: Status.loading,
      morningSlots: const [],
      eveningSlots: const [],
      clearError: true,
    ));
    final date = day.date;
    if (date == null) return;
    final result = await _booking.slots(
      date: date,
      doctorId: state.doctorId,
      medicalCenterId: state.medicalCenterId,
      specializationId: state.specializationId,
    );
    if (result.data != null) {
      emit(state.copyWith(
        slotsStatus: Status.success,
        morningSlots: result.data!.morning,
        eveningSlots: result.data!.evening,
      ));
    } else {
      emit(state.copyWith(
        slotsStatus: Status.failure,
        errorMessage: result.error?.message,
      ));
    }
  }

  void selectSlot(BookingSlot slot) {
    emit(state.copyWith(selectedSlot: slot, clearError: true));
  }

  Future<void> loadPreview() async {
    if (!state.canPreview) return;
    emit(state.copyWith(previewStatus: Status.loading, clearError: true));
    try {
      final result = await _booking.preview(
        doctorId: state.doctorId!,
        medicalCenterId: state.medicalCenterId,
        date: state.selectedDay!.date!,
        time: state.selectedSlot!.time!,
        note: state.note,
      );
      if (result.data != null) {
        emit(state.copyWith(
          previewStatus: Status.success,
          preview: result.data,
        ));
      } else {
        emit(state.copyWith(
          previewStatus: Status.failure,
          errorMessage: result.error?.message,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
          previewStatus: Status.failure, errorMessage: e.message));
    }
  }

  /// Final step. Backend returns a `PatientReservationResource` with the
  /// new booking_number and `status: pending`.
  Future<void> confirm() async {
    if (!state.canPreview) return;
    emit(state.copyWith(
      confirmStatus: Status.loading,
      booked: false,
      clearError: true,
    ));
    try {
      final result = await _booking.createReservation(
        doctorId: state.doctorId!,
        medicalCenterId: state.medicalCenterId,
        date: state.selectedDay!.date!,
        time: state.selectedSlot!.time!,
        note: state.note,
      );
      if (result.data != null) {
        emit(state.copyWith(
          confirmStatus: Status.success,
          confirmed: result.data,
          booked: true,
        ));
      } else {
        emit(state.copyWith(
          confirmStatus: Status.failure,
          errorMessage: result.error?.message,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
          confirmStatus: Status.failure, errorMessage: e.message));
    }
  }

  void reset() => emit(const BookingState());
}
