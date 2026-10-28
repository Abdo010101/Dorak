import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class BookingState extends Equatable {
  const BookingState({
    this.status = Status.initial,
    this.schedules = const [],
    this.placeId,
    this.doctorId,
    this.selectedDay,
    this.selectedTime,
    this.booked = false,
    this.errorMessage,
  });

  final Status status;
  final List<Schedules> schedules;
  final int? placeId;
  final int? doctorId;
  final Week? selectedDay;
  final String? selectedTime;
  final bool booked;
  final String? errorMessage;

  BookingState copyWith({
    Status? status,
    List<Schedules>? schedules,
    int? placeId,
    int? doctorId,
    Week? selectedDay,
    String? selectedTime,
    bool? booked,
    String? errorMessage,
    bool clearError = false,
  }) =>
      BookingState(
        status: status ?? this.status,
        schedules: schedules ?? this.schedules,
        placeId: placeId ?? this.placeId,
        doctorId: doctorId ?? this.doctorId,
        selectedDay: selectedDay ?? this.selectedDay,
        selectedTime: selectedTime ?? this.selectedTime,
        booked: booked ?? this.booked,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  bool get canConfirm =>
      doctorId != null && selectedDay != null && selectedTime != null;

  @override
  List<Object?> get props => [
        status,
        schedules,
        placeId,
        doctorId,
        selectedDay,
        selectedTime,
        booked,
        errorMessage,
      ];
}
