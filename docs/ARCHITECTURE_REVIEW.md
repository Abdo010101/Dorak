# Architecture Review: HR Attendance Management System

**Date**: April 2026
**Reviewer**: Software Architect Agent
**Scope**: Full-stack review — Backend (NestJS), Dashboard (React), Mobile (Flutter)
**Codebase Root**: `/Users/mahmoudawad/Documents/VibeCoding/hr`

---

## Table of Contents

1. [Overall Architecture Assessment](#1-overall-architecture-assessment)
2. [Backend Architecture](#2-backend-architecture)
3. [Frontend Architecture (Dashboard)](#3-frontend-architecture-dashboard)
4. [Mobile Architecture](#4-mobile-architecture)
5. [Cross-cutting Concerns](#5-cross-cutting-concerns)
6. [Database Design Review](#6-database-design-review)
7. [API Design Review](#7-api-design-review)
8. [Scalability Concerns](#8-scalability-concerns)
9. [Code Quality Issues](#9-code-quality-issues)
10. [Recommendations](#10-recommendations-prioritized)

---

## 1. Overall Architecture Assessment

### System Overview

The system is a three-tier HR attendance platform consisting of a NestJS REST API backend, a React dashboard for administrative roles, and a Flutter mobile app for employees. The components communicate exclusively over HTTP/REST. Real-time push is delegated to Firebase Cloud Messaging.

### Strengths

- **Clear separation of client types.** Dashboard and mobile are intentionally distinct clients with separate auth flows (`/auth/dashboard/login` vs `/auth/login`). This is architecturally correct — it avoids polluting one client's concerns into the other.

- **Consistent module pattern in the backend.** Every feature follows the same NestJS structure: `module.ts`, `controller.ts`, `service.ts`, `entities/`, `dto/`. This makes the codebase immediately navigable for any new developer.

- **Clean Architecture in mobile.** The Flutter app correctly separates `domain/repositories` (abstract contracts), `data/` (implementations), and `presentation/` (BLoC + pages). The `AttendanceRepository` interface at `/mobile/lib/features/attendance/domain/repositories/attendance_repository.dart` is a textbook example of this layer isolation.

- **BaseEntity is shared.** All entities inherit from a single `BaseEntity` at `/backend/src/common/entities/base.entity.ts`, which provides `id`, `createdAt`, `updatedAt`, and `deletedAt` consistently across the entire schema.

- **Soft delete is pervasive.** The `deletedAt` column from `BaseEntity` is used for soft-delete across users, leaves, departments, and holidays. A trash/restore cycle is fully implemented in the dashboard.

- **Audit logging is in place.** The `AuditService` at `/backend/src/modules/audit/audit.service.ts` logs INSERT, UPDATE, and DELETE events with old/new values, and correctly sanitizes sensitive fields like `password` and `refreshToken`.

- **JWT with refresh-token rotation.** Both clients implement token refresh via a 401-triggered interceptor and retry the original request transparently.

- **Rate limiting on auth endpoints.** `@Throttle({ default: { limit: 5, ttl: 60000 } })` is applied to `/auth/login` and `/auth/dashboard/login`, which guards against brute-force attacks.

- **Timezone-aware date handling.** The custom utility at `/backend/src/common/utils/timezone.util.ts` ensures all "today" boundary calculations use the company's configured IANA timezone rather than server UTC. This is a sophisticated and correct solution.

### Weaknesses (Summary — detailed in later sections)

- `synchronize: true` is used in development mode, but the production deployment relies on manual `ALTER TABLE` commands tracked in `CLAUDE.md`. There is exactly one migration file in the entire migrations directory.
- `getPolicies()` hits the database on every call across at least 15 execution paths, with no caching.
- The `reports/generateMonthlyReport` method spawns a `Promise.all` that issues N×3 database queries (one per employee) with no pagination.
- Biometric login in the mobile app stores the plaintext password in secure storage with a `TODO: Phase 2` comment that has not been resolved.
- The dashboard's `ProtectedRoute` does not verify token expiry client-side; it only checks `isAuthenticated` (a boolean in Zustand persisted storage).
- The mobile `AuthInterceptor` uses `_isRefreshing` as a simple boolean flag — concurrent 401 responses could trigger multiple refresh races.

---

## 2. Backend Architecture

### 2.1 Module Organization

The backend at `/backend/src/modules/` contains 15 feature modules:

```
auth, users, attendance, leaves, departments, settings, notifications,
reports, audit, permissions, upload, projects, work-logs, app-config,
penalties, weekly-summary
```

This is well-organized. Each module is self-contained and registered in `/backend/src/app.module.ts`. The import order (AuditModule first) is intentional because AuditModule is a dependency of UsersModule.

One structural issue: `forwardRef()` is used in two places:
- `AttendanceModule` imports `WorkLogsModule` via `forwardRef`
- `AuthModule` imports `PermissionsModule` via `forwardRef`

Forward references indicate a **circular dependency** between modules. This is an architectural smell. The `AttendanceService` directly calls `WorkLogsService.create()` during checkout — this tight coupling should be inverted: the checkout flow should not own work-log creation.

### 2.2 Dependency Injection

NestJS DI is used correctly. All services are `@Injectable()`. Repositories are injected via `@InjectRepository()`. The constructor injection pattern is consistent.

Weak point: The `ReportsService` at `/backend/src/modules/reports/reports.service.ts` imports `AttendanceService`, `LeavesService`, `UsersService`, and `SettingsService` directly. This creates a fat service with broad dependencies. Reports should read from the database directly or through a dedicated read model, not by re-using operational services.

### 2.3 Authentication & Authorization

The auth architecture is clean:

- `JwtStrategy` validates the token and attaches the user to the request.
- `JwtAuthGuard` is applied globally at the module level (inferred from `@UseGuards(JwtAuthGuard)` on controllers).
- `@Public()` decorator bypasses the guard for login/refresh endpoints.
- `RolesGuard` uses the `@Roles()` decorator for coarse role-based access.

Gap: The `RolesGuard` and the dynamic `PermissionsService` are two parallel systems. The dashboard UI uses `hasPermission()` from Zustand to conditionally render UI elements, but backend API endpoints only check roles via `@Roles()` decorator — not the dynamic permission flags stored in `role_permissions` table. This means a permission change in the `PermissionsPage` of the dashboard has **no effect on backend enforcement**. It only hides UI elements on the dashboard.

### 2.4 Settings Service — Uncached Hot Path

`SettingsService.getPolicies()` performs a full table scan on `policy_settings` every time it is called. Based on `Grep` analysis, it is called in at least 15 execution paths:

- `AttendanceService.checkIn()` (via `getDayBounds()`)
- `AttendanceService.checkOut()` (via `getDayBounds()`)
- `AttendanceService.checkOutWithWorkLog()` (via `getDayBounds()`)
- `AttendanceService.manualCheckIn()`
- `AttendanceService.manualCheckOut()`
- `AttendanceService.resetTodayAttendance()`
- `AttendanceService.validateRemoteWork()`
- `PenaltiesService.recordLatePenalty()` (twice per call)
- `PenaltiesService.recordAbsencePenalty()`
- `LeavesService.createRequest()`
- `ReportsService.calculateWorkingDays()`
- `WeeklySummaryService.calculateWeeklySummary()`
- `WeeklySummaryService.getCurrentWeekSummary()`

Every attendance check-in involves at minimum 2-3 calls to `getPolicies()`. There is no cache layer.

### 2.5 Password Handling Inconsistency

In `UsersService.changePassword()` (called via `AuthService`), the new password is hashed with `bcrypt.hash(newPassword, 10)`, then stored by calling `usersService.update(userId, { password: hashedPassword })`. However, the `User` entity's `@BeforeInsert/@BeforeUpdate` hook at `/backend/src/modules/users/entities/user.entity.ts` hashes the `password` virtual field before saving. Passing an already-hashed value through `update()` risks double-hashing if the field name matches the hook's trigger condition. The `update()` path bypasses the hook correctly only because it sets the raw `password` key not `passwordHash`, but this is fragile and non-obvious.

### 2.6 Notification Loops

In `LeavesService.createRequest()`, notifications are sent to the supervisor (1 query for FCM token) and to all HR managers (N queries). For `sendAnnouncement()` in `NotificationsService`, the system creates individual database notification records for every active user in a sequential loop. For a company with 200 employees this means 200 individual INSERT statements in one request.

---

## 3. Frontend Architecture (Dashboard)

### 3.1 Component Structure

The dashboard at `/dashboard/src/` uses a flat page structure: all page components live directly under `/pages/`. There are 18 route-level pages. No shared component library directory structure was observed beyond the existing `/components/Layout.tsx`.

The routing in `App.tsx` uses nested `<Routes>` inside a `ProtectedRoute` wrapper. This is functionally correct but uses the older nested-routes pattern. The route list has grown to 18 entries and is currently maintained manually.

### 3.2 State Management

`authStore.ts` uses Zustand with the `persist` middleware. The persisted slice includes:
- `user` (full user object including permissions object)
- `accessToken` (JWT string)
- `refreshToken` (JWT string)

**Security observation**: The `accessToken` and `refreshToken` are stored in `localStorage` (Zustand's default persistence target). This exposes both tokens to any JavaScript running on the page (XSS attack vector). A more secure approach stores the refresh token in an `httpOnly` cookie.

The `isAuthenticated` flag is set to `true` on login and `false` on logout. However, it is never re-validated after page reload. If a user's token is revoked server-side (e.g., logout from another device), the dashboard will still consider the user authenticated until the next API call returns 401.

### 3.3 API Layer

`/dashboard/src/services/api.ts` is a single large file (298 lines) containing all API functions grouped into export objects (`authApi`, `employeesApi`, etc.). This is a practical and consistent pattern for a project of this size.

The 401 interceptor in `api.ts` correctly retries with new tokens. However, there is a race condition: if two requests fire simultaneously and both get 401 responses, both will attempt to refresh the token. The first one will succeed; the second will fail because the old refresh token has been rotated. The dashboard would log out unexpectedly. The mobile `AuthInterceptor` has the same issue (see Section 4.3).

The `me` endpoint in `authApi` uses `POST /auth/me` instead of the standard `GET /auth/me`. This is a minor RESTful convention deviation.

### 3.4 Permission Enforcement in UI

`hasPermission()` in `authStore.ts` is used throughout the dashboard to conditionally render elements. However, the permissions object in the store is populated only once at login time. If an admin modifies permissions via `PermissionsPage`, the change only takes effect for the affected user after they log out and back in. There is no mechanism to refresh permissions without a full re-login.

---

## 4. Mobile Architecture

### 4.1 Clean Architecture Adherence

The Flutter app correctly implements three Clean Architecture layers across all features:

```
features/
  attendance/
    data/
      datasources/   — AttendanceRemoteDataSource (HTTP calls)
      models/        — AttendanceRecord, AttendanceSummary (data transfer)
      repositories/  — AttendanceRepositoryImpl
    domain/
      repositories/  — AttendanceRepository (abstract interface)
    presentation/
      bloc/          — AttendanceBloc + events + states
      pages/
      widgets/
```

This structure is consistent across `auth`, `attendance`, `leaves`, `work_log`, and `approvals`. The domain layer has no imports from `data` or `presentation` — the dependency rule is respected.

### 4.2 BLoC Pattern Usage

The BLoC pattern is used correctly:
- Events model user intentions or lifecycle triggers.
- States model UI rendering requirements.
- All events are handled via `on<EventType>()` in the constructor.
- States extend `Equatable` for efficient rebuilds.

One gap: Error handling in BLoC event handlers is inconsistent. Some handlers parse error strings to produce user-friendly messages:

```dart
// attendance_bloc.dart
if (errorString.contains('400') || errorString.contains('already')) {
  errorMessage = 'لقد سجلت حضورك بالفعل اليوم';
}
```

This is brittle. The correct approach is to have the repository layer throw typed exceptions (e.g., `AlreadyCheckedInException`) and catch them specifically in the BLoC. Checking HTTP status codes as substrings of an error message string is fragile and hard to maintain.

Another gap: The `ApprovalsBloc` is registered in the DI container but not visible in `/mobile/lib/core/di/injection.dart`. The approvals feature at `/mobile/lib/features/approvals/` has its own bloc but the datasource and repository are not registered in `injection.dart` — this is either a bug or the feature creates its BLoC manually.

### 4.3 Token Refresh Race Condition

The `AuthInterceptor` in `/mobile/lib/core/di/injection.dart` uses `_isRefreshing` as an instance-level flag. However, the `Dio` instance is a singleton (registered as `registerLazySingleton`), while only one `AuthInterceptor` instance is added to it. This means `_isRefreshing` is effectively a singleton flag — which is the correct intent. However, the current implementation does not queue or replay concurrent failed requests during the refresh window. When refresh completes, only the one request inside `onError` is retried; any other concurrent 401 requests are silently dropped.

### 4.4 Biometric Security Issue

`SecureStorageService` at `/mobile/lib/core/storage/secure_storage.dart` stores the user's plaintext password in secure storage for biometric re-login:

```dart
// TODO: Phase 2 - Replace with refresh token based biometric login
await _storage.write(key: _savedPasswordKey, value: password);
```

The TODO comment is present but unresolved. Storing the plaintext password — even in `FlutterSecureStorage` — is a security risk. If the device is compromised (jailbroken/rooted) the password could be extracted. The correct approach is to store only the refresh token and use it to obtain new tokens on biometric unlock, without ever storing the plaintext password.

### 4.5 Router Pattern

`AppRouter.generateRoute()` uses a `switch` statement on named strings. This is the Navigator 1.0 pattern. While functional, it does not support deep linking, URL-based navigation, or typed route arguments. As the app grows, this becomes harder to maintain. The approach does not introduce a bug, but it is an older pattern compared to `go_router`.

---

## 5. Cross-cutting Concerns

### 5.1 Error Handling

**Backend**: NestJS's built-in exception filter handles most errors. `BadRequestException`, `NotFoundException`, `ForbiddenException`, `UnauthorizedException` are used consistently. All Arabic-language error messages are inline in the service layer — they are not centralized in a constants file.

Inconsistency: `LeavesService.reviewRequest()` wraps the entire method in `try/catch` and then re-throws with `throw error`. This adds noise without adding value. The inner `try/catch` around the notification call is correctly scoped.

`console.error` appears in `leaves.service.ts` and other files alongside the proper NestJS `Logger`. The project mixes both patterns.

**Mobile**: All BLoC error handlers emit generic Arabic error strings. Debug `print()` calls remain in production-path code (22 occurrences across 8 files including `auth_bloc.dart`, `attendance_bloc.dart`, `auth_remote_datasource.dart`).

### 5.2 Logging

**Backend**: `AttendanceService` correctly uses `new Logger(AttendanceService.name)`. `PenaltiesService` and `NotificationsService` also use the NestJS Logger. However, `leaves.service.ts` mixes `console.error` with the Logger.

There is no structured log format configured. In production, `pm2 logs` produces mixed NestJS-formatted and raw `console.*` output, which makes log parsing difficult.

### 5.3 Validation

The backend uses the global `ValidationPipe` with `whitelist: true` and `forbidNonWhitelisted: true`. This is correct and prevents extra fields from leaking into services.

However, the `manual/check-in` and `manual/check-out` endpoints in `AttendanceController` accept an inline anonymous object `{ userId: string; checkIn: string; date?: string }` instead of a dedicated DTO class. This bypasses the class-validator decorators and means these fields receive no length, format, or presence validation at the pipe level.

### 5.4 Authentication Flow

The dual authentication flow (mobile login vs dashboard login) is a strength, but it introduces a subtle token security concern: both flows issue the same JWT payload format (`sub`, `email`, `role`). A JWT token issued by the mobile endpoint would be accepted by the dashboard API — there is no audience (`aud`) claim to differentiate them. An employee could theoretically use their mobile-issued token to call dashboard-only endpoints if they discover the API directly.

---

## 6. Database Design Review

### 6.1 Entity Relationships

The core entity graph is:

```
departments (1) ---- (N) users
users (1) ---- (N) attendance_records
users (1) ---- (N) leave_requests
users (1) ---- (N) leave_balances
users (1) ---- (N) work_schedules
attendance_records (1) ---- (1) daily_work_logs
daily_work_logs (1) ---- (N) work_log_entries
work_log_entries (N) ---- (1) projects
projects (N) ---- (1) project_types
users (1) ---- (N) notifications
users (1) ---- (N) monthly_penalties
users (1) ---- (N) weekly_summaries
```

The schema is normalized to 3NF. The use of UUID primary keys throughout is correct for a distributed system.

The `users` table has a self-referential `supervisor_id` FK. The `UsersService.getAllTeamMembersRecursive()` method handles the hierarchy by making repeated async queries in JavaScript (application-level recursion with `maxDepth: 2`). At depth 2 this issues 1 + N + N*M queries where N is the number of direct reports and M is the number of their reports. This is an N+1 pattern wrapped in recursion.

### 6.2 Settings as EAV Table

`policy_settings` is implemented as an Entity-Attribute-Value (EAV) table: `(key, value)`. `getPolicies()` fetches all rows and converts them to a typed object in JavaScript. The advantages are maximum flexibility for adding new settings without schema changes. The disadvantages are:

- No type safety at the database level — all values are stored as text or JSONB
- No database-level validation for settings values
- Each `getPolicies()` call loads the entire settings table

For the current scale (fewer than 30 policy keys) this is acceptable, but the lack of caching makes it a bottleneck.

### 6.3 Indexing

The following indexes are in place (from entity `@Index` decorators):

| Table | Index |
|---|---|
| `attendance_records` | `(userId, checkIn)` |
| `leave_requests` | `(userId, status)` |
| `leave_balances` | `(userId, year)` — unique on `(userId, leaveType, year)` |
| `notifications` | `(userId, isRead)` |
| `audit_logs` | `(tableName, recordId)` |
| `monthly_penalties` | `(userId, month, year)` — unique |
| `weekly_summaries` | `(userId, weekStart)` — unique |

Missing indexes:
- `attendance_records(checkIn)` — queries filter by date range without userId (e.g., `getDashboardStats`, `getEmployeesLatestLocations`)
- `leave_requests(startDate, endDate)` — overlap detection queries use these columns
- `users(supervisorId)` — `getTeamMembers` and `getAllTeamMembersRecursive` filter on this column
- `users(status)` — `findAll` with status filter is used frequently
- `daily_work_logs(userId, date)` — `findMyLogs` and `getTodayLogForUser` filter on both

### 6.4 Migration Strategy

The project contains exactly **one migration file**: `1733661600000-UpdateHolidayDates.ts`. All other schema evolution relies on TypeORM's `synchronize: true` in development mode. Production schema changes are applied manually via `ALTER TABLE` commands documented in `CLAUDE.md`.

This is a critical operational risk. The manual tracking approach in `CLAUDE.md` is error-prone and does not scale. The `CLAUDE.md` troubleshooting section already documents a class of production bugs caused by this approach ("column does not exist after deployment").

### 6.5 LeaveBalance Computed Property

`LeaveBalance.remainingDays` is a TypeScript getter that computes `totalDays - usedDays - pendingDays`. This is not a database column. Queries that need remaining days must load the entity into memory and access the getter. It is not possible to filter or sort by `remainingDays` at the database level without recomputing in SQL.

---

## 7. API Design Review

### 7.1 Versioning

The global API prefix is `api/v1` (set in `main.ts`). All endpoints are versioned at the prefix level. This is consistent and correct for a v1 API.

There is no mechanism yet to introduce `api/v2` for breaking changes while maintaining backward compatibility with existing mobile clients.

### 7.2 RESTful Conventions

Most endpoints follow REST conventions well. Notable deviations:

| Endpoint | Issue |
|---|---|
| `POST /auth/me` | Should be `GET /auth/me` — this retrieves a resource |
| `POST /reports/export/csv` | Export of a resource should be `GET` with `Accept: text/csv` or a query parameter; `POST` implies mutation |
| `DELETE /attendance/reset/:userId` | Reset is not a pure deletion; semantics are closer to `POST /attendance/:userId/reset` |
| `PUT /leaves/:id/cancel` | Cancellation is a state transition; `POST /leaves/:id/cancel` would be more idiomatic |

### 7.3 Pagination

None of the list endpoints implement pagination. `getAll` for employees, leave requests, audit logs, and notifications return the full result set. The audit log in particular will grow unboundedly — the `findAll` method supports `limit` and `offset` parameters internally, but the controller at `/backend/src/modules/audit/audit.controller.ts` must be verified to expose these.

The `getUserNotifications` method hard-limits results to 50 with `.take(50)` — this is better than no limit, but it is a silent truncation with no `total` count returned to the client.

### 7.4 Response Shape

API responses are inconsistent in their envelope structure:
- Most endpoints return the entity or array directly
- `AuditService.findAll()` returns `{ data, total }` 
- `AttendanceService.checkOutWithWorkLog()` returns `{ attendance, workLog }`
- Most other endpoints return the entity directly

There is no global response envelope. Consumers cannot rely on a consistent top-level structure.

### 7.5 Error Response Shape

NestJS's default exception filter produces:
```json
{ "statusCode": 400, "message": "...", "error": "Bad Request" }
```
This is the standard NestJS format and is used consistently. The mobile app and dashboard do not rely on the `error` field, only the `message`.

---

## 8. Scalability Concerns

### 8.1 getPolicies() Database Fan-out

As documented in Section 2.4, `getPolicies()` is called on every attendance operation with no cache. At 100 simultaneous check-ins (morning rush), this generates 200-300 redundant identical queries to the `policy_settings` table. An in-memory cache with a TTL of 60 seconds would eliminate this entirely.

### 8.2 Monthly Report N+1 Pattern

`ReportsService.generateMonthlyReport()` calls `Promise.all(employees.map(async (employee) => { ... }))`. For each employee it issues:
1. `attendanceService.getMonthlySummary()` — 1 query
2. `leavesService.getAllBalances()` — 1 query
3. `calculateLeaveDaysInMonth()` — which calls `leavesService.getUserRequests()` — 1 query

For 50 employees this is 150 database queries per report generation. This should be replaced with batch queries joined at the SQL level.

### 8.3 Notification Loops

`NotificationsService.sendAnnouncement()` iterates over all active users and issues one `INSERT` per user. For 200 employees this is 200 sequential inserts. These should use a bulk insert: `notificationRepository.save(notificationArray)`.

Similarly, `setBulkBalance()` in `LeavesService` iterates over all users and issues one `findOne` + one `save` per user — up to 400 queries for a 200-person company. This should use an upsert operation.

### 8.4 getAllTeamMembersRecursive — Application-level Tree Walk

`UsersService.getAllTeamMembersRecursive()` traverses the supervisor hierarchy with recursive `async` calls, issuing one database query per level. At depth 2 for a supervisor with 10 direct reports each having 5 subordinates, this is 1 + 10 + 50 = 61 queries. PostgreSQL's `WITH RECURSIVE` CTE would solve this in a single query.

### 8.5 No Caching Layer

The system has no caching infrastructure (no Redis, no NestJS `CacheModule`). All data is fetched fresh from PostgreSQL on every request. For read-heavy operations like `getPolicies()`, `getWorkLocation()`, and user lookups, even a short TTL cache would significantly reduce database load.

### 8.6 File Upload Strategy

`UploadModule` serves files via `ServeStaticModule` from the local filesystem (`/uploads`). This approach does not scale horizontally — if the backend is ever deployed to multiple instances, uploaded files would not be shared. The files should be served from object storage (S3, Cloudflare R2, etc.).

---

## 9. Code Quality Issues

### 9.1 `any` Type Usage

TypeScript's `any` type is used in multiple service files:

- `AttendanceService.updateRecord(recordId, updateData: Partial<AttendanceRecord>)` — then internally does `Object.assign(record, updateData)` with no type guard
- `LeavesService.getAllRequests(query: LeaveQueryDto)` — `const where: any = {}`
- `ReportsService.generateMonthlyReport()` — `status: 'active' as any`
- `AuthService.updateProfile()` — the parameter type is `any`

Using `as any` or untyped `where` objects to work around TypeScript bypasses compile-time guarantees that are one of the main benefits of using TypeScript over JavaScript.

### 9.2 DTO Defined Inside Controller

`AuthController` at `/backend/src/modules/auth/auth.controller.ts` defines `UpdateProfileDto` and `ChangePasswordDto` inline at the top of the file:

```typescript
class UpdateProfileDto {
  @IsOptional()
  @IsString()
  nameAr?: string;
  ...
}
```

These DTOs belong in a `dto/` directory alongside `login.dto.ts`. Inline class definitions are not reusable and do not follow the project's own conventions.

### 9.3 Hard-coded Business Logic

Weekend days are hard-coded as `[5, 6]` (Friday, Saturday) in `LeavesService.calculateWorkingDays()`. The comment says "Adjust based on company policy" but it does not read from `policies.weekendDays`, which is available. The `ReportsService.calculateWorkingDays()` correctly reads from `policies.weekendDays`. These two implementations are inconsistent.

Days-of-the-week blocked for remote work are hard-coded as `[0, 4]` (Sunday, Thursday) as the default in `validateRemoteWork()`, which also correctly reads from `policies.blockedRemoteDays`. The hard-coded default is fine, but the inconsistency with `LeavesService` indicates the policies system is not used uniformly.

### 9.4 print() Calls in Production Mobile Code

22 occurrences of `print()` in production Flutter code including in `auth_bloc.dart` and `attendance_bloc.dart`. In Flutter, `print()` outputs to the device console and is not stripped from release builds unless explicitly disabled. These should use a structured logger (e.g., the `logger` package) or be removed.

### 9.5 Approval Feature Not Registered in DI

The approvals feature at `/mobile/lib/features/approvals/` includes a BLoC (`approvals_bloc.dart`) but neither `ApprovalsBloc`, its repository, nor its data source appear in `/mobile/lib/core/di/injection.dart`. If `ApprovalsPage` uses `getIt<ApprovalsBloc>()` it will throw at runtime. If it creates the BLoC directly, it bypasses the DI container's singleton management.

### 9.6 LeaveBalance Mutation Without Transaction

`LeavesService.createRequest()` updates `balance.pendingDays` and saves the balance separately from the leave request entity:

```typescript
const savedRequest = await this.leaveRequestRepository.save(request);
balance.pendingDays += totalDays;
await this.leaveBalanceRepository.save(balance);
```

If the second save fails, the leave request will exist in the database but the balance will not be updated. These two operations should be wrapped in a database transaction.

### 9.7 User Soft-Delete Referential Integrity

When `softDelete` is called on a `User`, the `users` record receives a `deleted_at` timestamp. However, the user may still be referenced as a `supervisorId` by other active users. TypeORM's soft-delete does not cascade these relationships. The dashboard's trash/restore cycle for users should check for active relationships before deletion.

---

## 10. Recommendations (Prioritized)

### Priority 1 — Critical (Address Before Next Production Deployment)

**R1: Introduce proper database migrations.**
Stop relying on `synchronize: true` and manual `ALTER TABLE`. Configure TypeORM's migration runner. Every schema change must be a migration file committed with the code change it supports.

Related files: `/backend/src/app.module.ts` (TypeORM config), `/backend/src/database/migrations/`

**R2: Fix biometric plaintext password storage in mobile.**
Replace the `_savedPasswordKey` store with a refresh-token-based re-authentication flow. The user's plaintext password must not be persisted in device storage.

Related file: `/mobile/lib/core/storage/secure_storage.dart`

**R3: Wrap LeaveBalance mutations in database transactions.**
`createRequest`, `reviewRequest`, and `cancelRequest` in `LeavesService` modify two tables without a transaction. Use `dataSource.transaction()` or TypeORM's `QueryRunner`.

Related file: `/backend/src/modules/leaves/leaves.service.ts`

**R4: Fix weekend day inconsistency in leave calculation.**
`LeavesService.calculateWorkingDays()` hard-codes Friday+Saturday as the weekend. It must read from `policies.weekendDays` the same way `ReportsService.calculateWorkingDays()` does.

Related file: `/backend/src/modules/leaves/leaves.service.ts` line 573

### Priority 2 — High (Address in Next Sprint)

**R5: Cache `getPolicies()` results.**
Add a short-lived (60s) in-memory or Redis cache to `SettingsService.getPolicies()`. This eliminates the most prevalent N-query pattern in the system. NestJS `CacheModule` with `@nestjs/cache-manager` can be added without changing any call sites — inject `CacheManager` in `SettingsService` and wrap `getPolicies()`.

Related file: `/backend/src/modules/settings/settings.service.ts`

**R6: Replace application-level recursive tree walk with a SQL CTE.**
`UsersService.getAllTeamMembersRecursive()` should use a PostgreSQL `WITH RECURSIVE` query. This reduces N+1 queries to one and handles arbitrary depth.

Related file: `/backend/src/modules/users/users.service.ts` lines 229-257

**R7: Fix concurrent 401 token refresh race condition.**
Both the dashboard API interceptor and the mobile `AuthInterceptor` need a pending-refresh queue: if `_isRefreshing` is true, queue the failed request's promise and resolve it after the refresh succeeds, rather than immediately proceeding or dropping the request.

Related files: `/dashboard/src/services/api.ts`, `/mobile/lib/core/di/injection.dart`

**R8: Convert report generation to batch queries.**
`ReportsService.generateMonthlyReport()` should use raw SQL queries with GROUP BY to aggregate per-employee attendance data, rather than calling `getMonthlySummary()` per employee.

Related file: `/backend/src/modules/reports/reports.service.ts`

**R9: Backend enforcement of dynamic permissions.**
The backend currently only enforces role-level access via `@Roles()`. Dynamic permissions from the `role_permissions` table must also be checked server-side. Create a `PermissionsGuard` that reads from the permissions service, replacing or augmenting `RolesGuard` where fine-grained control is needed.

Related files: `/backend/src/modules/permissions/`, `/backend/src/modules/auth/guards/roles.guard.ts`

### Priority 3 — Medium (Backlog)

**R10: Add missing database indexes.**
Add indexes on: `users(supervisor_id)`, `users(status)`, `attendance_records(check_in)` (without userId), `leave_requests(start_date, end_date)`, `daily_work_logs(user_id, date)`.

**R11: Move DTOs out of AuthController.**
Move `UpdateProfileDto` and `ChangePasswordDto` from `/backend/src/modules/auth/auth.controller.ts` to `/backend/src/modules/auth/dto/`.

**R12: Replace print() with a logger in mobile.**
Add the `logger` Flutter package. Replace all 22 `print()` calls. Configure the logger to suppress output in release builds.

**R13: Use bulk insert for notifications.**
Replace the per-user insert loop in `sendAnnouncement()` and `sendToDepartment()` with a single `save(arrayOfNotifications)` call.

**R14: Add JWT audience claim.**
Add an `aud` claim to tokens generated by `dashboardLogin` to prevent mobile tokens from being accepted by dashboard-only endpoints.

Related file: `/backend/src/modules/auth/auth.service.ts`

**R15: Standardize API response envelope.**
Define and document a consistent response shape for list endpoints: `{ data: T[], total: number, page: number, limit: number }`. Implement pagination on `getAll` endpoints for employees, leaves, audit logs, and work logs.

**R16: Resolve approvals feature DI registration.**
Register `ApprovalsBloc`, its repository implementation, and its data source in `/mobile/lib/core/di/injection.dart`.

**R17: Migrate mobile router to go_router.**
Replace the Navigator 1.0 string-switch router with `go_router` for deep link support and typed route parameters.

**R18: Move file uploads to object storage.**
Replace the local filesystem upload strategy with S3-compatible object storage. This is required before horizontal scaling of the backend is possible.

---

## Appendix: Key File Reference

| Component | File | Role |
|---|---|---|
| Backend entry | `/backend/src/main.ts` | Bootstrap, CORS, global pipes, Swagger |
| Module registry | `/backend/src/app.module.ts` | All modules, DB config, rate limiting |
| Base entity | `/backend/src/common/entities/base.entity.ts` | UUID PK, timestamps, soft-delete |
| Enums | `/backend/src/common/enums/index.ts` | All domain enumerations |
| Timezone util | `/backend/src/common/utils/timezone.util.ts` | Timezone-aware day bounds |
| Auth service | `/backend/src/modules/auth/auth.service.ts` | Login, token generation, dashboard login |
| Attendance service | `/backend/src/modules/attendance/attendance.service.ts` | Core business logic |
| Settings service | `/backend/src/modules/settings/settings.service.ts` | Policy fetching (uncached) |
| Permissions service | `/backend/src/modules/permissions/permissions.service.ts` | Dynamic role-permission matrix |
| Dashboard API | `/dashboard/src/services/api.ts` | All HTTP calls, 401 interceptor |
| Dashboard auth store | `/dashboard/src/store/authStore.ts` | Zustand auth state |
| Dashboard router | `/dashboard/src/App.tsx` | Route definitions |
| Mobile DI | `/mobile/lib/core/di/injection.dart` | GetIt registrations, AuthInterceptor |
| Mobile API client | `/mobile/lib/core/network/api_client.dart` | Dio wrapper |
| Mobile router | `/mobile/lib/core/router/app_router.dart` | Named route definitions |
| Mobile secure storage | `/mobile/lib/core/storage/secure_storage.dart` | Token and credential storage |
