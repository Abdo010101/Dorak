import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/repository/repository.dart';
import 'notification_state.dart';

/// Replaces the data-fetch surface of `NotificationController`.
///
/// Permission-handler + FCM init stay in a dedicated service (legacy
/// `NotificationController` still holds that bootstrap until Phase 9d).
class NotificationCubit extends Cubit<NotificationFeedState> {
  NotificationCubit({required NotificationsRepository notificationsRepository})
      : _repo = notificationsRepository,
        super(const NotificationFeedState());

  final NotificationsRepository _repo;

  Future<void> loadFirstPage() => _fetch(pageKey: 1, replace: true);

  void setEnabled(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
  }

  /// `POST /patient/notifications/{id}/mark-as-read` (scope §10.2). Updates
  /// the local item optimistically — backend echoes the full row but mobile
  /// does not refetch for one tap.
  Future<void> markAsRead(String id) async {
    final result = await _repo.markAsRead(id);
    if (result.error != null) {
      emit(state.copyWith(errorMessage: result.error?.message));
      return;
    }
    final next = state.items
        .map((n) => n.id == id ? (n..isRead = true) : n)
        .toList(growable: false);
    emit(state.copyWith(items: next));
  }

  /// `POST /patient/notifications/mark-all-as-read` (scope §10.2).
  Future<void> markAllAsRead() async {
    final result = await _repo.markAllAsRead();
    if (result.error != null) {
      emit(state.copyWith(errorMessage: result.error?.message));
      return;
    }
    final next = state.items.map((n) => n..isRead = true).toList(growable: false);
    emit(state.copyWith(items: next));
  }

  Future<void> _fetch({required int pageKey, required bool replace}) async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await _repo.getNotifications(pageKey: pageKey);
      final data = result.data;
      if (data != null) {
        emit(
          state.copyWith(
            status: Status.success,
            items: replace ? data : [...state.items, ...data],
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
}
