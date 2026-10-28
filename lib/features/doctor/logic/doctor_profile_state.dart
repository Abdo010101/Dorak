import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

enum DoctorProfileTab { clinic, offers }

class DoctorProfileState extends Equatable {
  const DoctorProfileState({
    this.status = Status.initial,
    this.profile,
    this.offers = const [],
    this.tab = DoctorProfileTab.clinic,
    this.selectedPlaceIndex,
    this.errorMessage,
  });

  final Status status;
  final DoctorProfileResponse? profile;
  final List<OfferResponse> offers;
  final DoctorProfileTab tab;
  final int? selectedPlaceIndex;
  final String? errorMessage;

  Places? get selectedPlace {
    final list = profile?.places;
    final i = selectedPlaceIndex;
    if (list == null || i == null || i < 0 || i >= list.length) return null;
    return list[i];
  }

  DoctorProfileState copyWith({
    Status? status,
    DoctorProfileResponse? profile,
    List<OfferResponse>? offers,
    DoctorProfileTab? tab,
    int? selectedPlaceIndex,
    String? errorMessage,
    bool clearError = false,
  }) =>
      DoctorProfileState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        offers: offers ?? this.offers,
        tab: tab ?? this.tab,
        selectedPlaceIndex: selectedPlaceIndex ?? this.selectedPlaceIndex,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, profile, offers, tab, selectedPlaceIndex, errorMessage];
}
