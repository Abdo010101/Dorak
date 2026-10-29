import 'package:flutter/widgets.dart';

import 'app_empty_state.dart';
import 'app_error_state.dart';
import 'app_loading_state.dart';

/// Portable view phases. Status-agnostic — zero coupling to any
/// feature-side state enum. Convert from an app's own enum via
/// `AppStatusViewX.fromStatus` (see `app_status_view_x.dart`).
enum AppViewPhase { loading, error, empty, success }

/// Caller-supplied labels for the fallback error / empty / retry copy.
/// This app wires `.tr()` keys via `AppStatusView.labelsBuilder` in `main`.
class AppStatusViewLabels {
  const AppStatusViewLabels({
    this.errorTitle = 'Something went wrong',
    this.retryLabel = 'Retry',
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
  });

  final String errorTitle;
  final String retryLabel;
  final String emptyTitle;
  final String? emptyMessage;
}

/// One call renders loading / error / empty / success.
///
/// Override any phase by passing a prebuilt widget. The success branch
/// is required and built via a `WidgetBuilder` so it participates in the
/// normal `Element` lifecycle.
class AppStatusView extends StatelessWidget {
  const AppStatusView({
    super.key,
    required this.phase,
    required this.builder,
    this.errorMessage,
    this.onRetry,
    this.loading,
    this.error,
    this.empty,
    this.labels,
  });

  final AppViewPhase phase;
  final WidgetBuilder builder;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget? error;
  final Widget? empty;
  final AppStatusViewLabels? labels;

  /// Global fallback labels. A new app that wants static copy sets this
  /// once at bootstrap.
  static AppStatusViewLabels defaultLabels = const AppStatusViewLabels();

  /// Builder for localized labels. Called per build so locale switches
  /// re-read i18n keys. Takes precedence over `defaultLabels` when set.
  static AppStatusViewLabels Function(BuildContext context)? labelsBuilder;

  AppStatusViewLabels _resolveLabels(BuildContext context) =>
      labels ?? labelsBuilder?.call(context) ?? defaultLabels;

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case AppViewPhase.loading:
        return loading ?? const AppLoadingState();
      case AppViewPhase.error:
        final l = _resolveLabels(context);
        return error ??
            AppErrorState(
              title: l.errorTitle,
              message: errorMessage,
              onRetry: onRetry,
              retryLabel: l.retryLabel,
            );
      case AppViewPhase.empty:
        final l = _resolveLabels(context);
        return empty ??
            AppEmptyState(title: l.emptyTitle, message: l.emptyMessage);
      case AppViewPhase.success:
        return builder(context);
    }
  }
}
