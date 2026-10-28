import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class NotificationFeedState extends Equatable {
  const NotificationFeedState({
    this.status = Status.initial,
    this.items = const [],
    this.notificationsEnabled = false,
    this.errorMessage,
  });

  final Status status;
  final List<NotificationModel> items;
  final bool notificationsEnabled;
  final String? errorMessage;

  NotificationFeedState copyWith({
    Status? status,
    List<NotificationModel>? items,
    bool? notificationsEnabled,
    String? errorMessage,
    bool clearError = false,
  }) =>
      NotificationFeedState(
        status: status ?? this.status,
        items: items ?? this.items,
        notificationsEnabled:
            notificationsEnabled ?? this.notificationsEnabled,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, items, notificationsEnabled, errorMessage];
}
