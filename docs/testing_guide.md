# Testing Guide

## Testing Pyramid

```
        ┌──────────┐
        │  E2E     │  Maestro — few, critical paths only
        │ (Maestro)│
        ├──────────┤
        │  Widget  │  Flutter widget tests — key screens
        │  Tests   │
        ├──────────┤
        │  Unit    │  bloc_test + mocktail — most tests here
        │  Tests   │
        └──────────┘
```

| Layer | Tool | Target | Count |
|-------|------|--------|-------|
| Unit | `bloc_test` + `mocktail` | Blocs, Cubits, UseCases, Repositories | 70% of tests |
| Widget | `flutter_test` | Screens, form validation, RTL | 20% of tests |
| E2E | Maestro | Login flow, critical user journeys | 10% of tests |

## Coverage Targets

| Release | Target |
|---------|--------|
| R1 MVP | > 70% |
| R2 Extended | > 80% |
| R3 Polish | > 85% |

## Unit Testing

### What to Test

| Layer | What | Example |
|-------|------|---------|
| Bloc/Cubit | All states + events | Login: loading → success → error |
| UseCase | Business logic | CreateOrder validates balance |
| Repository | Data mapping | JSON → Entity conversion |
| Validators | Edge cases | Phone: null, empty, invalid, valid |

### What NOT to Test

- Generated code (`.freezed.dart`, `.g.dart`)
- Flutter framework widgets (MaterialApp, Scaffold)
- Third-party packages (Dio, GoRouter internals)
- Simple getters/setters with no logic

### Test File Structure

```
apps/corp/test/
├── helpers/
│   └── test_helpers.dart              ← Mock classes, fakes, setup
├── features/
│   ├── auth/
│   │   ├── logic/
│   │   │   └── auth_bloc_test.dart
│   │   ├── domain/
│   │   │   └── login_usecase_test.dart
│   │   └── data/
│   │       └── auth_repository_impl_test.dart
│   ├── vehicles/
│   │   ├── logic/
│   │   │   └── vehicle_bloc_test.dart
│   │   └── ...
│   └── ...
└── widget_test.dart                   ← App launch test
```

### Bloc Test Pattern

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;

  // 2. Setup before each test
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authBloc = AuthBloc(loginUseCase: mockLoginUseCase);
  });

  // 3. Cleanup
  tearDown(() => authBloc.close());

  // 4. Test initial state
  test('initial state is AuthInitial', () {
    expect(authBloc.state, isA<AuthInitial>());
  });

  // 5. Test success path
  blocTest<AuthBloc, AuthState>(
    'emits [Loading, Success] when login succeeds',
    build: () {
      when(() => mockLoginUseCase.execute(any()))
          .thenAnswer((_) async => mockUser);
      return authBloc;
    },
    act: (bloc) => bloc.add(
      LoginRequested(phone: '0501234567', password: 'TestPass1'),
    ),
    expect: () => [
      isA<AuthLoading>(),
      isA<AuthSuccess>(),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase.execute(any())).called(1);
    },
  );

  // 6. Test error path
  blocTest<AuthBloc, AuthState>(
    'emits [Loading, Error] when login fails',
    build: () {
      when(() => mockLoginUseCase.execute(any()))
          .thenThrow(ServerFailure(
            apiErrorModel: ApiErrorModel(message: 'Invalid credentials'),
          ));
      return authBloc;
    },
    act: (bloc) => bloc.add(
      LoginRequested(phone: '0501234567', password: 'wrong'),
    ),
    expect: () => [
      isA<AuthLoading>(),
      isA<AuthError>(),
    ],
  );
}
```

### UseCase Test Pattern

```dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = LoginUseCase(mockRepo);
  });

  test('returns User on success', () async {
    when(() => mockRepo.login(
      phone: any(named: 'phone'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => mockUser);

    final result = await useCase.execute(
      LoginParams(phone: '0501234567', password: 'TestPass1'),
    );

    expect(result, mockUser);
  });

  test('throws ServerFailure on invalid credentials', () {
    when(() => mockRepo.login(
      phone: any(named: 'phone'),
      password: any(named: 'password'),
    )).thenThrow(ServerFailure(
      apiErrorModel: ApiErrorModel(message: 'Invalid'),
    ));

    expect(
      () => useCase.execute(LoginParams(phone: '0501234567', password: 'x')),
      throwsA(isA<ServerFailure>()),
    );
  });
}
```

### Repository Test Pattern

```dart
void main() {
  late AuthRepositoryImpl repo;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    repo = AuthRepositoryImpl(mockApiClient);
  });

  test('returns User from API response', () async {
    when(() => mockApiClient.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              data: {'success': true, 'data': {'id': '1', 'name': 'Test'}},
              statusCode: 200,
              requestOptions: RequestOptions(),
            ));

    final result = await repo.login(phone: '0501234567', password: 'Test1');
    expect(result.name, 'Test');
  });
}
```

### Mock Setup (test_helpers.dart)

```dart
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockCacheHelper extends Mock implements CacheHelper {}
class MockTokenManager extends Mock implements TokenManager {}

class FakeOptions extends Fake implements Options {}

void registerFallbackValues() {
  registerFallbackValue(FakeOptions());
}
```

## Widget Testing

### When to Widget Test

- Forms with validation feedback
- Screens with conditional UI (loading/error/empty/success)
- RTL layout verification
- Complex interactive widgets

### Widget Test Pattern

```dart
void main() {
  testWidgets('Login shows error on empty phone', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => MockAuthBloc(),
          child: const LoginPage(),
        ),
      ),
    );

    // Tap login without entering phone
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pump();

    // Verify error shown
    expect(find.text('رقم الهاتف مطلوب'), findsOneWidget);
  });
}
```

## E2E Testing (Maestro)

### When to E2E Test

- Login/register flow (critical path)
- Payment flow (money involved)
- Full navigation smoke test (no crashes)
- Before every release

### Structure

```
maestro/
├── config.yaml
└── flows/
    ├── auth-login.yaml
    ├── auth-login-failure.yaml
    ├── smoke-full-navigation.yaml
    ├── vehicles-crud.yaml
    ├── orders-create.yaml
    ├── wallet-charge.yaml
    └── support-ticket.yaml
```

### Running Maestro

```bash
# Single flow
maestro test maestro/flows/auth-login.yaml

# All flows
maestro test maestro/flows/

# With studio (visual)
maestro studio

# CI output
maestro test maestro/flows/ --format junit
```

### Maestro Tips

| Tip | Example |
|-----|---------|
| Arabic text matching | `".*تسجيل.*"` — use regex |
| Optional elements | `optional: true` — onboarding, tutorials |
| Wait for async | `extendedWaitUntil` with timeout |
| Screenshots | `takeScreenshot: 01_step_name` |
| Env vars | `${TEST_PHONE}` — never hardcode credentials |

## Running Tests

```bash
# All tests in Corp
cd apps/corp && flutter test

# Specific test file
flutter test test/features/auth/logic/auth_bloc_test.dart

# With coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Shared package tests
cd packages/utils && flutter test

# All packages
for pkg in packages/*/; do (cd "$pkg" && flutter test 2>/dev/null); done
```

## Test Naming Convention

```
[unit_under_test]_test.dart

auth_bloc_test.dart         ← Bloc test
login_usecase_test.dart     ← UseCase test
auth_repo_impl_test.dart    ← Repository test
validators_test.dart        ← Utility test
login_page_test.dart        ← Widget test
```

## Test Naming (inside file)

```dart
group('AuthBloc', () {
  group('LoginRequested', () {
    test('emits [Loading, Success] when login succeeds', () {});
    test('emits [Loading, Error] when credentials invalid', () {});
    test('emits [Loading, Error] when network offline', () {});
  });
});
```

Pattern: `[action] when [condition]` or `returns [result] on [input]`
