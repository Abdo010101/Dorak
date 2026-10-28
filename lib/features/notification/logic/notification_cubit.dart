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
