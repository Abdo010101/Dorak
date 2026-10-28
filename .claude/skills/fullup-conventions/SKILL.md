---
name: fullup-conventions
description: How Fullup features are actually coded — layers, Cubit + Equatable state, use cases, mock data sources, manual getIt registration, routing, localization. Load before writing or reviewing any Dart code under apps/ or packages/features/.
---

# Fullup code conventions

These rules describe what the code does today. Where an older doc says otherwise
(injectable annotations, freezed states, Either, mockito), follow this file and the
reference feature.

**Reference feature — copy its shape:** `apps/delivery/lib/features/home/`
(tests: `apps/delivery/test/features/home/`). Read it before starting a new feature.

## Repo

- Pub workspaces (root `pubspec.yaml`, no Melos). `flutter pub get` and `flutter analyze` run from the repo root; `flutter test` runs from inside the app or package folder.
- Apps with real code: `apps/delivery`, `apps/worker`. `apps/corp` has only `core/`.
  `apps/pay` and `apps/provider` are stubs. `apps/individuals` (client + vehicle-driver flows in one app) is in progress.
- Shared features live in `packages/features/{auth,chat,notifications,profile,settings}`.
  Check there (and `packages/ui_kit`) before building anything an app might already get for free.
- Device capabilities are shared too: image picking (camera / gallery) is `packages/core/media`
  (`fullup_media`: `ImagePickerService`, `PickImageUseCase`, `DiscardImageUseCase`), with
  `FullupImageUploadField` and `FullupOptionSheet` in ui_kit. Register the service in the app's
  getIt; never call the `image_picker` plugin from an app.
  QR scanning is `packages/core/scanner` (`fullup_scanner`: `FullupQrScannerView`,
  `FullupQrScannerController.rescan()`), with `FullupScanFrame` in ui_kit; never use
  `mobile_scanner` from an app for QR codes.
- No app-specific code in shared packages. Do not edit a shared package unless the task says so.

## Feature layout

```
lib/features/<feature>/
├── data/
│   ├── datasources/   <feature>_remote_datasource.dart (abstract)
│   │                  mock_<feature>_remote_datasource.dart
│   ├── dtos/          <name>_dto.dart        fromJson + toEntity()
│   └── repositories/  <feature>_repository_impl.dart
├── domain/
│   ├── entities/      <name>_entity.dart, result enums
│   ├── repositories/  <feature>_repository.dart (abstract)
│   └── usecases/      <verb>_<noun>_usecase.dart
├── logic/             <feature>_cubit.dart, <feature>_state.dart
└── presentation/
    ├── pages/
    └── widgets/
```

Dependencies point inward only: presentation → logic → domain ← data.
Widgets never see DTOs, data sources or Dio. Domain imports nothing from data or Flutter UI.

Entities and states are `Equatable`; DTOs have a hand-written `fromJson`. No freezed,
json_serializable or build_runner in new code (team decision). The freezed models in
`packages/core/models` are legacy: do not copy that style.

## State — Cubit + Equatable

Cubit only (no Bloc, no freezed, no sealed classes).

```dart
enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.initial, this.dashboard, this.errorMessage});

  final HomeStatus status;
  final HomeDashboardEntity? dashboard;

  /// One-shot error message (cleared on the next emit).
  final String? errorMessage;

  HomeState copyWith({HomeStatus? status, HomeDashboardEntity? dashboard, String? errorMessage}) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage, // not preserved on purpose
    );
  }

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}
```

- One-shot fields (error messages, action results) are passed straight through in
  `copyWith` so they clear on the next emit.
- Keep loaded data in state while reloading, so pull-to-refresh does not blank the screen.
- Cubit constructor takes use cases as named `required` params. Inject time and
  intervals (`DateTime Function()? clock`) instead of calling `DateTime.now()` inline.
- Cancel timers and subscriptions in `close()`.

## Errors

- Repositories return `Future<Entity>` and let exceptions propagate. No Either.
- The cubit catches, logs and emits:

```dart
} on Object catch (error, stackTrace) {
  log('Failed to load home dashboard', error: error, stackTrace: stackTrace);
  emit(state.copyWith(status: HomeStatus.error, errorMessage: error.toString()));
}
```

- `log` comes from `dart:developer`. Never `print`.
- An expected business outcome is a value, not an exception: model it as a domain
  enum (see `domain/entities/availability_result.dart`).
- A failure the UI must react to specifically gets its own exception class in
  `domain/exceptions/`.

## Use cases

One class per action, `const` constructor, repository passed positionally, `call()`:

```dart
class GetHomeDashboardUseCase {
  const GetHomeDashboardUseCase(this._repository);
  final HomeRepository _repository;

  Future<HomeDashboardEntity> call() => _repository.getDashboard();
}
```

Business rules (validation, combining repositories, permission checks) live here,
not in widgets and not in the cubit.

## Data — mock at the data source

The backend is a separate team and usually behind. Build UI first on mock data:

- `MockXxxRemoteDataSource implements XxxRemoteDataSource`, next to the abstract class.
- It returns **JSON maps passed through the real DTO** (`XxxDto.fromJson({...})`),
  so mapping is exercised and swapping to the real API changes one DI line.
- Constructor takes `delay` (default ~600 ms) so tests can pass `Duration.zero`.
- The repository impl is real from day one: call the data source, return `dto.toEntity()`.
- Prices, taxes, totals and permissions come from the backend response. Never compute them locally.

## Dependency injection — manual getIt

One file per app: `apps/<app>/lib/core/di/injection_container.dart`. No annotations, no build_runner.

```dart
// Home feature (mock data source until API is ready)
..registerLazySingleton<HomeRemoteDataSource>(MockHomeRemoteDataSource.new)
..registerLazySingleton<HomeRepository>(
  () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
)
..registerFactory(() => GetHomeDashboardUseCase(getIt<HomeRepository>()))
..registerFactory(
  () => HomeCubit(getDashboard: getIt<GetHomeDashboardUseCase>()),
)
```

- Data sources and repositories: `registerLazySingleton`. Use cases and cubits: `registerFactory`.
- A cubit that needs an id: `registerFactoryParam<OrderDetailsCubit, String, void>`.
- Keep the `(mock data source until API is ready)` comment on mock registrations.
- Shared feature packages are wired through their config object (e.g. `AuthFeatureConfig`).

## Routing

`apps/<app>/lib/core/router/app_router.dart`: add a `static const String` path to
`AppRoutes` (kebab-case, nested by section: `'/settings/quick-login'`) and a `GoRoute`.
Navigate with `context.go(AppRoutes.x)` / `context.push(...)`. Never `Navigator.push`.

## Localization

- easy_localization, JSON, nested keys: `apps/<app>/assets/translations/`.
  Delivery and Worker: `ar.json`, `en.json`, `ur.json`. Corp: `ar.json`, `en.json`.
- Use raw dotted keys: `'home.welcome'.tr()`. There is no generated keys class.
- Every new key goes into **every** locale file of that app in the same change.
  `apps/delivery/test/translations_test.dart` fails when key sets differ.
- Arabic is the primary language: write the Arabic copy first, properly, not as a
  translation of the English.
- No hardcoded user-facing strings anywhere, including error fallbacks and mock UI labels.

## Screens

Every screen renders four states: loading, success, empty, error (with retry).
UI rules and the widget catalog are in the `fullup-ui-kit` skill.

## Requirements

| App | Read first |
|-----|-----------|
| Worker | `docs/brd/Worker-BRD-V3.md` (update §92 when a module lands) |
| Corp | `docs/srs/FullUp-Corp-Mobile-SRS.md` |
| Delivery | `docs/brd/Delivery-BRD-V3.pdf`, `apps/delivery/lib/features/home/README.md` |
| Pay | `docs/brd/Pay-NFC-BRD-V3.pdf` |
| Provider | `docs/brd/Provider-BRD-V1.pdf`, `docs/srs/FullUp-Provider-Mobile-SRS.docx` |
| Individuals / Driver (Client & Driver app) | `docs/brd/Client-Driver-BRD-V2.md` (update §92 when a module lands) |

Cite the BRD section (`§n`) or rule id (`BR-xx`, `REQ-xx`) in a doc comment where
a business rule is implemented.

## Before reporting done

```bash
dart format <only the files you changed>
flutter analyze apps/<app>
```

Never run `dart format .` or any `git checkout` / `git restore` / `git stash`:
other sessions edit this working tree at the same time.
