# Fullup — Coding Rules & Standards

## Coding Principles (Karpathy-Inspired)

### 1. Think Before Coding
- State assumptions explicitly — if uncertain, ask rather than guess
- Present multiple interpretations — don't pick silently when ambiguity exists
- Push back when a simpler approach exists
- Stop when confused — name what's unclear

### 2. Simplicity First
- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

### 3. Surgical Changes
- Touch only what you must
- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

### 4. Goal-Driven Execution
- Define success criteria, loop until verified
- Write tests first when fixing bugs
- Ensure tests pass before and after refactoring

---

## Dart Guidelines

### Naming

| Convention | Where |
|-----------|-------|
| `PascalCase` | Classes, enums, typedefs |
| `camelCase` | Variables, functions, methods, parameters |
| `snake_case` | File names, directory names |
| `UPPERCASE` | Environment variables, constants |

- Start functions with a verb: `fetchUser()`, `saveOrder()`, `deleteCard()`
- Boolean variables start with: `isLoading`, `hasError`, `canDelete`
- Use complete words, not abbreviations (except: `i/j` loops, `err` errors, `ctx` context)

### Types

- Always declare types for variables, parameters, and return values
- Avoid `dynamic` unless absolutely necessary
- Use `final` for variables that don't change
- Use `const` for compile-time constants
- Use `Equatable` for immutable data classes (entities, states) with `final` fields and a hand-written `copyWith` — no freezed in new code

### Functions

- Short functions with single purpose (< 20 instructions)
- Avoid nesting — use early returns
- Use higher-order functions (`map`, `filter`, `reduce`) over loops
- Use expression functions (`=>`) for simple functions (< 3 instructions)
- Use default parameter values instead of null checks
- One export per file

### Classes

- Follow SOLID principles
- Prefer composition over inheritance
- Small classes (< 200 instructions, < 10 public methods, < 10 properties)
- Declare interfaces to define contracts

---

## Flutter Rules

### Project Structure
- Clean architecture: Presentation → Domain → Data
- Feature-first organization under `lib/features/`
- Shared code in `packages/`
- Core utilities in `lib/core/`

### State Management
- BLoC for complex state with multiple events
- Cubit for simpler state management
- Never mutate state directly — always emit new states
- Keep BLoC/Cubit logic pure — no UI dependencies
- State classes extend `Equatable` with a status enum and a hand-written `copyWith` (see `apps/delivery/lib/features/home/logic/home_state.dart`)
- Handle loading, success, empty, and error states explicitly
- Don't store UI data (TextEditingController) in BLoC/Cubit

### Dependency Injection
- Always use getIt, registered by hand (apps do not use injectable annotations)
- Register in `lib/core/di/injection_container.dart`
- Use `registerLazySingleton` for services, data sources and repositories
- Use `registerFactory` for Cubits and use cases (`registerFactoryParam` when a Cubit needs an id)
- Never create instances directly in UI

### Navigation
- go_router for all navigation
- Define routes in `lib/core/router/app_router.dart`
- Use named routes
- Pass data via route parameters or `extra`
- Handle deep linking
- Use `ShellRoute` for bottom navigation

### Networking
- Dio for all HTTP requests
- Centralize in `ApiClient` (in `packages/core/networking`)
- Use interceptors for auth, logging, error handling, rate limiting
- Parse API responses to domain entities, not raw JSON
- Cache when appropriate
- Never expose API keys in code

### Storage
- SharedPreferences for simple key-value storage
- SecureStorage for sensitive data (tokens, passwords)
- Clear sensitive data on logout
- Use the shared `storage` package

### UI & Widgets
- Break large widgets into smaller, reusable components
- Use `const` constructors wherever possible
- Avoid deep widget nesting — extract to separate files
- Use `flutter_screenutil` for responsive design
- Use `ThemeData` — don't hardcode colors/sizes
- Use widgets from `packages/ui_kit`

### Localization
- `easy_localization` for all user-facing strings
- Never hardcode text strings in widgets
- Translations in `packages/localization/assets/translations/`
- App-specific translations in `apps/[app]/assets/translations/`
- Support RTL for Arabic
- Send `Accept-Language` header with API requests

### Performance
- `const` widgets and `BlocBuilder`/`BlocSelector` to avoid rebuilds
- `ListView.builder` for long lists (never `ListView` with children)
- Lazy load data (pagination, infinite scroll)
- Dispose controllers and subscriptions properly
- Image caching (`cached_network_image`)
- No heavy computation on main thread

### Security
- Never commit API keys or tokens to version control
- Use SecureStorage for auth tokens
- Validate and sanitize all user inputs
- HTTPS for all API calls
- ProGuard/R8 enabled in Android release
- Keychain (iOS) / EncryptedSharedPreferences (Android) for tokens

### Error Handling
- Use Result/Either pattern or try-catch appropriately
- User-friendly error messages, not stack traces
- Log errors with `dart:developer`
- Retry logic for network errors when appropriate
- Handle edge cases: empty lists, null values, network failures, timeouts

---

## Screen States

Every screen must handle four states:

| State | Description |
|-------|-------------|
| **Loading** | Show shimmer/skeleton while data is being fetched |
| **Success** | Render data normally |
| **Empty** | Show empty-state message/illustration |
| **Error** | Show error message with retry option |

---

## Testing

| Type | What | Tools |
|------|------|-------|
| Unit tests | BLoCs, Cubits, UseCases, Services | `flutter_test`, `bloc_test`, `mocktail` |
| Widget tests | UI components | `flutter_test` |
| Integration tests | Critical user flows | `integration_test` |
| E2E tests | Full app flows | Maestro (see [guides/maestro_e2e_testing.md](guides/maestro_e2e_testing.md)) |

- Follow Arrange-Act-Assert convention
- Name variables: `inputX`, `mockX`, `actualX`, `expectedX`
- Mock external dependencies
- Tests should be fast, independent, repeatable

---

## Git & Version Control

- Clear, descriptive commit messages
- Small, focused commits (one logical change per commit)
- Meaningful branch names
- Don't commit generated files (except injectable outputs)

### Version Naming

```
Major.Minor.Patch
1.0.0  →  First release
1.1.0  →  New feature
1.1.1  →  Bug fix
2.0.0  →  Breaking change
```

Build numbers (iOS `CFBundleVersion`, Android `versionCode`) always increment — never decrease.

---

## Code Review Checklist

- [ ] Code follows project architecture and patterns
- [ ] No linter errors or warnings
- [ ] All dependencies properly injected
- [ ] Error handling implemented
- [ ] UI is responsive and accessible
- [ ] Strings are localized
- [ ] Tests written (if applicable)
- [ ] No hardcoded values or magic numbers
- [ ] Code properly formatted
- [ ] Unused code removed
- [ ] Platform consistency (iOS + Android)

---

## Platform Consistency

- Same UX on iOS and Android (unless clear reason to differ)
- Handle platform differences:
  - Safe Area (notch, dynamic island)
  - Navigation gestures (back swipe iOS vs back button Android)
  - Keyboard behavior
  - Permission dialogs
