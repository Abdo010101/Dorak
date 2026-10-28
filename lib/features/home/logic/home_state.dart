import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = Status.initial,
    this.home,
    this.bestDoctors = const [],
    this.latestOffers = const [],
    this.appointments = const [],
    this.errorMessage,
  });

  final Status status;
  final HomeResponse? home;
  final List<Doctor> bestDoctors;
  final List<OfferResponse> latestOffers;
  final List<AppointmentResponse> appointments;
  final String? errorMessage;

  HomeState copyWith({
    Status? status,
    HomeResponse? home,
    List<Doctor>? bestDoctors,
    List<OfferResponse>? latestOffers,
    List<AppointmentResponse>? appointments,
    String? errorMessage,
    bool clearError = false,
  }) =>
      HomeState(
        status: status ?? this.status,
        home: home ?? this.home,
        bestDoctors: bestDoctors ?? this.bestDoctors,

        latestOffers: latestOffers ?? this.latestOffers,
        appointments: appointments ?? this.appointments,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, home, bestDoctors, latestOffers, appointments, errorMessage];
}
