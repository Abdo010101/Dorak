import 'package:flutter/widgets.dart';

import '../../state/status.dart';
import 'app_status_view.dart';

/// Bridge between this app's `Status` enum and the portable
/// `AppStatusView`. Drop this one file when porting to an app that
/// does not use `Status`.
class AppStatusViewX {
  const AppStatusViewX._();

  /// Convenience ctor from this app's `Status` enum.
  static Widget fromStatus({
    Key? key,
    required Status status,
    required WidgetBuilder builder,
    bool isEmpty = false,
    String? errorMessage,
    VoidCallback? onRetry,
    Widget? loading,
    Widget? error,
    Widget? empty,
    AppStatusViewLabels? labels,
  }) {
    final phase = switch (status) {
      Status.initial || Status.loading => AppViewPhase.loading,
      Status.failure => AppViewPhase.error,
      Status.success =>
        isEmpty ? AppViewPhase.empty : AppViewPhase.success,
    };
    return AppStatusView(
      key: key,
      phase: phase,
      builder: builder,
      errorMessage: errorMessage,
      onRetry: onRetry,
      loading: loading,
      error: error,
      empty: empty,
      labels: labels,
    );
  }
}
