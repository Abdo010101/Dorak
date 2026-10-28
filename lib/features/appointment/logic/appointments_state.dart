import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

enum AppointmentsTab { upcoming, past, cancelled }

class AppointmentsState extends Equatable {
  const AppointmentsState({
    this.status = Status.initial,
    this.tab = AppointmentsTab.upcoming,
    this.items = const [],
    this.errorMessage,
  });

  final Status status;
  final AppointmentsTab tab;
  final List<AppointmentResponse> items;
  final String? errorMessage;

  AppointmentsState copyWith({
    Status? status,
    AppointmentsTab? tab,
    List<AppointmentResponse>? items,
    String? errorMessage,
    bool clearError = false,
  }) =>
      AppointmentsState(
        status: status ?? this.status,
        tab: tab ?? this.tab,
        items: items ?? this.items,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, tab, items, errorMessage];
}
