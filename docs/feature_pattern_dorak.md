# Dorak Feature Pattern (reference)

> Produced from the Phase 7 pilot (`lib/features/settings/`). Phase 8 features copy this skeleton.

## Folder layout

```
lib/features/<name>/
├── data/
│   ├── datasources/   # retrofit clients + remote datasources
│   ├── dtos/          # JSON ↔ Dart DTOs
│   └── repositories/  # repositories_impl implements domain contracts
├── domain/
│   ├── entities/      # pure Dart; no `package:flutter/*`
│   ├── repositories/  # abstract contracts
│   └── usecases/      # single-method callables (`class XxxUseCase { call(...) }`)
├── logic/
│   ├── <name>_cubit.dart   # or <name>_bloc.dart for event-driven flows
│   └── <name>_state.dart   # Equatable + `Status` enum from `core/state/status.dart`
├── presentation/
│   ├── pages/<name>_page.dart
│   └── widgets/<local widgets>.dart
└── README.md
```

## Imports allowed per layer

| Layer | May import |
|---|---|
| `domain/` | pure Dart; `equatable` |
| `data/` | `domain/`, retrofit/dio, DTOs |
| `logic/` | `domain/`, `core/state/*`, `bloc`, `equatable` |
| `presentation/` | `logic/`, `core/ui_kit/*`, `core/theme/*`, `core/router/*`, `flutter_bloc`, `easy_localization`, `go_router` |

**Never** in `presentation/`: raw `Color`, raw `TextStyle`, `AppColors.*`, `Navigator.pushNamed`, direct repository/retrofit imports.

## State shape

```dart
import 'package:equatable/equatable.dart';
import '../../../core/state/status.dart';

class XxxState extends Equatable {
  const XxxState({
    this.status = Status.initial,
    this.data,
    this.errorMessage,
  });

  final Status status;
  final XxxEntity? data;
  final String? errorMessage;

  XxxState copyWith({Status? status, XxxEntity? data, String? errorMessage, bool clearError = false}) =>
      XxxState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, data, errorMessage];
}
```

## Cubit shape

```dart
class XxxCubit extends Cubit<XxxState> {
  XxxCubit({required this.repository}) : super(const XxxState());
  final XxxRepository repository;

  Future<void> load() async {
    emit(state.copyWith(status: Status.loading, clearError: true));
    try {
      final result = await repository.fetch();
      emit(state.copyWith(status: Status.success, data: result));
    } on DioException catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.message));
    }
  }
}
```

## Page shape

```dart
class XxxPage extends StatelessWidget {
  const XxxPage({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final spacing = AppSpacing.of(context);
    return Scaffold(
      backgroundColor: colors.surfaceField,
      appBar: AppTopBar(title: 'xxx.title'.tr()),
      body: BlocBuilder<XxxCubit, XxxState>(
        builder: (ctx, state) => switch (state.status) {
          Status.loading => const AppLoadingState(),
          Status.failure => AppErrorState(
              title: state.errorMessage ?? 'unknown_error'.tr(),
              onRetry: () => ctx.read<XxxCubit>().load(),
            ),
          _ => _Content(state: state),
        },
      ),
    );
  }
}
```

## Test shape

- `test/features/<name>/logic/<name>_cubit_test.dart` — `bloc_test` + `mocktail`.
- `test/features/<name>/presentation/<name>_page_test.dart` — widget test with `BlocProvider.value` + a `MockCubit`.

Pilot reference files:
- `lib/features/settings/logic/{language,app_review}_{cubit,state}.dart`
- `lib/features/settings/presentation/pages/{settings,language,app_review}_page.dart`
- `test/features/settings/logic/*.dart`
- `test/features/settings/presentation/settings_page_test.dart`

## Routing

Routes live in `lib/core/router/app_router.dart`. Add a `GoRoute` with `name:` equal to `RouteNames.<name>` so legacy call-sites keep working. Navigate with `context.goNamed(RouteNames.<name>)`.

## i18n

Every user-facing string flows through `easy_localization`:

```dart
Text('rate_quality'.tr())
```

Both `assets/translations/en.json` and `assets/translations/ar.json` get the key, same shape.
