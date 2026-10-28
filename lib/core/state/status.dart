/// Base status enum used by every Cubit/Bloc state in Dorak.
///
/// Matches `docs/feature_guide.md`:
/// - `initial` — nothing loaded yet, show empty-state shell.
/// - `loading` — in-flight; show loader/skeleton.
/// - `success` — data populated; render content.
/// - `failure` — error occurred; show error-state widget + retry.
enum Status { initial, loading, success, failure }

extension StatusX on Status {
  bool get isInitial => this == Status.initial;
  bool get isLoading => this == Status.loading;
  bool get isSuccess => this == Status.success;
  bool get isFailure => this == Status.failure;
}
