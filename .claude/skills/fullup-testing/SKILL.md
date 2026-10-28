---
name: fullup-testing
description: Fullup test conventions — bloc_test + mocktail, file layout and naming, cubit / use case / repository / widget test patterns, fixtures, run commands. Load before writing, reviewing or running tests.
---

# Fullup testing

**Reference tests — copy their shape:** `apps/delivery/test/features/home/`
(`logic/home_cubit_test.dart`, `domain/get_home_dashboard_usecase_test.dart`,
`data/home_repository_impl_test.dart`).

Libraries: `flutter_test`, `bloc_test`, `mocktail`. Not mockito, no codegen.

## What must be tested

Every Cubit, every UseCase, every Repository implementation. Key widgets get a widget
test, including one pumped in RTL (Arabic). Each must cover loading, success, empty
and error, plus edge cases (null, empty list, boundary values).

Coverage targets: R1 > 70%, R2 > 80%, R3 > 85%.

## Layout and naming

```
apps/<app>/test/
├── fixtures/<shared>_fixtures.dart          app-wide builders
├── translations_test.dart                   locale key parity guard
└── features/<feature>/
    ├── fixtures/<feature>_fixtures.dart
    ├── data/<feature>_repository_impl_test.dart
    ├── domain/<verb>_<noun>_usecase_test.dart
    ├── logic/<feature>_cubit_test.dart
    └── presentation/<page>_page_test.dart
```

Shared feature packages mirror `lib/src` instead (`test/data/repositories/`, `test/domain/usecases/`).

## Conventions

- Mocks are declared inline at the top of the test file:
  `class MockGetHomeDashboardUseCase extends Mock implements GetHomeDashboardUseCase {}`
- `late` mock variables assigned in `setUp`; a local `buildCubit()` factory; local
  or fixture `buildXxx({...})` entity builders with defaults.
- Variable names: `inputX`, `mockX`, `actualX`, `expectedX`. Blank line between
  arrange, act and assert.
- Test names are sentences describing behaviour: `'emits [loading, loaded] with the clock time'`.
  Group by method name.
- Time is injected (`clock: () => now`), never real. Use short `tickInterval`s for timers.
- `registerFallbackValue` in `setUpAll` when matching custom types with `any()`.

### Cubit

```dart
blocTest<HomeCubit, HomeState>(
  'emits [loading, error] when loading fails',
  build: () {
    when(() => mockGetDashboard()).thenThrow(Exception('offline'));
    return buildCubit();
  },
  act: (cubit) => cubit.loadDashboard(),
  expect: () => [
    const HomeState(status: HomeStatus.loading),
    isA<HomeState>()
        .having((state) => state.status, 'status', HomeStatus.error)
        .having((state) => state.errorMessage, 'errorMessage', isNotNull),
  ],
);
```

Assert the full emitted state list on success paths. Use `seed` for "already loaded"
cases and `verify` for interaction checks. Always include: success, failure, the
empty result, and "previous data survives a failed refresh" where it applies.

### Use case

Plain `test`: the happy path returns the repository value and
`verify(() => mockRepository.x()).called(1)`; a second test proves repository errors
are rethrown (`throwsException`). Add one test per business rule the use case enforces.

### Repository implementation

Run the **real** `XxxRepositoryImpl` over the lib's own mock data source to prove the
JSON → DTO → entity mapping:

```dart
import '.../mock_home_remote_datasource.dart' as fixture;

final repository = HomeRepositoryImpl(
  fixture.MockHomeRemoteDataSource(delay: Duration.zero, clock: () => inputNow),
);
```

For edge cases (null fields, empty lists, unknown enum strings) use a mocktail data
source returning `XxxDto.fromJson(const {...})`.

### Widget

Open an existing widget test in the same app first and pump the page the same way
(e.g. `apps/delivery/test/features/handover/presentation/handover_pages_test.dart`,
`apps/delivery/test/features/reports/presentation/report_widgets_test.dart`). Cover
each of the four states and one `Directionality(textDirection: TextDirection.rtl)` case.

### Translations

A feature that adds keys must keep `apps/<app>/test/translations_test.dart` green
(delivery has it; add the same guard when the app lacks one and the task includes strings).

## Running

```bash
(cd apps/<app> && flutter test test/features/<feature>/)   # one feature
(cd apps/<app> && flutter test)                            # whole app
(cd apps/<app> && flutter test --coverage)                 # with lcov
flutter analyze apps/<app>                                 # from the repo root
```

Run tests from **inside the app or package folder**. Widget tests load assets
relative to it: the same suite run from the repo root (`flutter test apps/worker`)
shows extra failures that are not real. Report real output: counts of passed / failed and the failing
test names with their messages. Never report green without having run the command.

No Maestro or simulator runs from agents: the team runs E2E by hand.
