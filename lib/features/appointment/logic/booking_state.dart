import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

/// Center vs clinic branch of the booking flow (scope §9.3/§9.4).
///
/// `center` posts `medical_center_id` with every call; `clinic` omits it
/// (sends `null`), so the stepper skips the specialty step.
enum BookingVariant { center, clinic }

class BookingState extends Equatable {
  const BookingState({
    this.variant = BookingVariant.center,
    this.doctorId,
    this.medicalCenterId,
    this.specializationId,
    this.daysStatus = Status.initial,
    this.days = const [],
    this.selectedDay,
    this.slotsStatus = Status.initial,
    this.morningSlots = const [],
    this.eveningSlots = const [],
    this.selectedSlot,
    this.previewStatus = Status.initial,
    this.preview,
    this.confirmStatus = Status.initial,
    this.confirmed,
    this.booked = false,
    this.errorMessage,
    this.note,
  });

  final BookingVariant variant;
  final int? doctorId;

  /// Null when [variant] is [BookingVariant.clinic].
  final int? medicalCenterId;

  /// Set when the user picks "any available doctor" at a center.
  final int? specializationId;

  final Status daysStatus;
  final List<BookingDay> days;
  final BookingDay? selectedDay;

  final Status slotsStatus;
  final List<BookingSlot> morningSlots;
  final List<BookingSlot> eveningSlots;
  final BookingSlot? selectedSlot;

  final Status previewStatus;
  final AppointmentResponse? preview;

  final Status confirmStatus;
  final AppointmentResponse? confirmed;
  final bool booked;

  final String? errorMessage;
  final String? note;

  bool get canLoadSlots => selectedDay != null && doctorId != null;
  bool get canPreview =>
      doctorId != null && selectedDay != null && selectedSlot != null;
  bool get canConfirm => preview != null;

  BookingState copyWith({
    BookingVariant? variant,
    int? doctorId,
    int? medicalCenterId,
    bool clearMedicalCenterId = false,
    int? specializationId,
    Status? daysStatus,
    List<BookingDay>? days,
    BookingDay? selectedDay,
    Status? slotsStatus,
    List<BookingSlot>? morningSlots,
    List<BookingSlot>? eveningSlots,
    BookingSlot? selectedSlot,
    bool clearSelectedSlot = false,
    Status? previewStatus,
    AppointmentResponse? preview,
    Status? confirmStatus,
    AppointmentResponse? confirmed,
    bool? booked,
    String? errorMessage,
    bool clearError = false,
    String? note,
  }) =>
      BookingState(
        variant: variant ?? this.variant,
        doctorId: doctorId ?? this.doctorId,
        medicalCenterId:
            clearMedicalCenterId ? null : medicalCenterId ?? this.medicalCenterId,
        specializationId: specializationId ?? this.specializationId,
        daysStatus: daysStatus ?? this.daysStatus,
        days: days ?? this.days,
        selectedDay: selectedDay ?? this.selectedDay,
        slotsStatus: slotsStatus ?? this.slotsStatus,
        morningSlots: morningSlots ?? this.morningSlots,
        eveningSlots: eveningSlots ?? this.eveningSlots,
        selectedSlot:
            clearSelectedSlot ? null : selectedSlot ?? this.selectedSlot,
        previewStatus: previewStatus ?? this.previewStatus,
        preview: preview ?? this.preview,
        confirmStatus: confirmStatus ?? this.confirmStatus,
        confirmed: confirmed ?? this.confirmed,
        booked: booked ?? this.booked,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        note: note ?? this.note,
      );

  @override
  List<Object?> get props => [
        variant,
        doctorId,
        medicalCenterId,
        specializationId,
        daysStatus,
        days,
        selectedDay,
        slotsStatus,
        morningSlots,
        eveningSlots,
        selectedSlot,
        previewStatus,
        preview,
        confirmStatus,
        confirmed,
        booked,
        errorMessage,
        note,
      ];
}
