# Security Audit Report — HR Attendance Management System

**Date:** 2026-04-06  
**Auditor:** Security Auditor Agent (Claude)  
**Scope:** Full-stack — Backend (NestJS), Dashboard (React/Zustand), Mobile (Flutter/Dio)  
**Verdict:** CONDITIONAL PASS — several issues must be resolved before the next production deployment.

---

## Executive Summary

The system demonstrates a solid security foundation: bcrypt-12 for password hashing, TypeORM parameterized queries throughout, JWT with short-lived access tokens (15m), secure token storage via `flutter_secure_storage`, and a well-structured RBAC system.

The audit found **0 Critical**, **2 High**, **7 Medium**, and **5 Low** severity issues. The most pressing concerns are:

- Plaintext passwords persisted in `flutter_secure_storage` for biometric re-login.
- Swagger API documentation exposed unconditionally in production with no authentication gate.
- HTTP security headers absent — Helmet is not installed.
- `ThrottlerModule` configured but the global `ThrottlerGuard` is never registered, making rate limiting inactive on all endpoints except the two login routes.
- Settings and leaves controllers accept raw inline `Partial<{...}>` body types that bypass `class-validator`.

---

## OWASP Top 10 Compliance Matrix

| OWASP Category | Status | Key Finding |
|---|---|---|
| A01 — Broken Access Control | PASS (with notes) | One IDOR on `GET /leaves/:id` |
| A02 — Cryptographic Failures | PARTIAL | Refresh token plaintext in DB; plaintext password in mobile secure storage |
| A03 — Injection | PASS | TypeORM parameterized queries used throughout; no raw SQL concatenation |
| A04 — Insecure Design | PARTIAL | No CSRF protection; Swagger exposed in production |
| A05 — Security Misconfiguration | FAIL | No Helmet; Swagger always enabled; CORS fallback is localhost |
| A06 — Vulnerable Components | PARTIAL | No automated audit run; versions appear recent |
| A07 — Auth Failures | PARTIAL | Biometric stores plaintext password; global throttler guard not registered |
| A08 — Data Integrity | PASS | Soft-delete patterns; no deserialization issues found |
| A09 — Logging Failures | PARTIAL | Audit sanitizes sensitive fields; IP/UA not captured; FCM token printed in mobile |
| A10 — SSRF | LOW RISK | `attachmentUrl` on leave requests accepts arbitrary strings; limited surface |

---

## Critical Issues

None identified.

---

## High Issues

### H-01 — Plaintext Password Stored in flutter_secure_storage for Biometric Login

| | |
|---|---|
| **File** | `/mobile/lib/core/storage/secure_storage.dart` |
| **Lines** | 78-84, 55-68 |
| **Severity** | HIGH |

`enableBiometric()` writes the user's plaintext password to the `saved_password` key in secure storage. `clearSession()` deliberately preserves this key on logout when biometric is enabled. A TODO comment acknowledges this is temporary. On a rooted/jailbroken device, or via backup extraction on older Android, the plaintext credential can be extracted and replayed against the API from any device.

```dart
// secure_storage.dart lines 82-83
// TODO: Phase 2 - Replace with refresh token based biometric login
await _storage.write(key: _savedPasswordKey, value: password);
```

**Impact:** Full account compromise if device is compromised.

**Fix:**
1. Remove `_savedPasswordKey` entirely.
2. On biometric success, use the stored `refreshToken` to call `POST /auth/refresh` and obtain a new access token. The refresh token is already stored securely and is the correct credential.

---

### H-02 — Swagger API Docs Exposed in Production Without Authentication

| | |
|---|---|
| **File** | `/backend/src/main.ts` |
| **Lines** | 31-45 |
| **Severity** | HIGH |

Swagger UI is set up unconditionally at `/docs` with no `NODE_ENV` guard and no access control. In production (`hr.webstdy.com/docs`), the complete API surface — all routes, schemas, example values, and the Bearer auth format — is publicly visible to unauthenticated users.

```typescript
// main.ts — no environment guard
const document = SwaggerModule.createDocument(app, config);
SwaggerModule.setup('docs', app, document);
```

**Impact:** Attackers can enumerate all endpoints and craft targeted attacks with no reconnaissance effort.

**Fix:**
```typescript
if (process.env.NODE_ENV !== 'production') {
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);
}
```

---

## Medium Issues

### M-01 — ThrottlerGuard Not Registered Globally — Rate Limiting Inactive

| | |
|---|---|
| **File** | `/backend/src/app.module.ts` |
| **Lines** | 38-42 |
| **Severity** | MEDIUM |

`ThrottlerModule.forRoot([{ ttl: 60000, limit: 30 }])` is registered but no global `ThrottlerGuard` provider is registered. Without the guard, the module initializes storage but enforces nothing. Only the two login endpoints have explicit `@Throttle` decorators. All other endpoints are unprotected.

**Fix — add to AppModule providers:**
```typescript
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard } from '@nestjs/throttler';

providers: [
  { provide: APP_GUARD, useClass: ThrottlerGuard },
],
```

---

### M-02 — No HTTP Security Headers (Helmet Not Installed)

| | |
|---|---|
| **File** | `/backend/src/main.ts` |
| **Lines** | 1-53 |
| **Severity** | MEDIUM |

The application does not use `helmet`. Missing headers: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security`, `Referrer-Policy`.

**Fix:**
```bash
npm install helmet
```
```typescript
import helmet from 'helmet';
app.use(helmet()); // first middleware
```

---

### M-03 — Settings and Leaves Controllers Bypass class-validator With Inline Body Types

| | |
|---|---|
| **File** | `/backend/src/modules/settings/settings.controller.ts` |
| **Lines** | 42, 55, 110, 128 |
| **Severity** | MEDIUM |

Multiple `@Body()` parameters are typed as ad-hoc TypeScript inline objects or `Partial<interface>`. TypeScript types are erased at runtime; `class-validator` only acts on decorated class instances.

**Fix:** Create dedicated DTO classes with `class-validator` decorators for every `@Body()` parameter.

---

### M-04 — IDOR: GET /leaves/:id Does Not Check Ownership

| | |
|---|---|
| **File** | `/backend/src/modules/leaves/leaves.controller.ts` |
| **Lines** | 99-103 |
| **Severity** | MEDIUM |

`GET /leaves/:id` passes the path UUID directly as a `userId` to `getUserRequests()` with no ownership check. Any authenticated employee can read another employee's leave requests.

**Impact:** Horizontal privilege escalation — full leave history of any employee is readable.

**Fix:** Compare the path parameter against `@CurrentUser('id')` and allow override only for SUPERVISOR/HR_MANAGER/ADMIN roles.

---

### M-05 — Manual Attendance Endpoints Accept Unvalidated Inline Body

| | |
|---|---|
| **File** | `/backend/src/modules/attendance/attendance.controller.ts` |
| **Lines** | 173-191 |
| **Severity** | MEDIUM |

`POST /attendance/manual/check-in` and `POST /attendance/manual/check-out` accept inline object types with no `@IsUUID()` on `userId`, no `@IsDateString()` on `checkIn`/`checkOut`.

**Fix:** Create `ManualCheckInDto` and `ManualCheckOutDto` with proper `class-validator` decorators.

---

### M-06 — Refresh Token Stored Plaintext in Database

| | |
|---|---|
| **File** | `/backend/src/modules/users/entities/user.entity.ts` |
| **Lines** | 76-80 |
| **Severity** | MEDIUM |

Refresh tokens are stored as plain strings in the `users.refresh_token` column. A database compromise exposes all current sessions (up to 7 days of silent authenticated access).

**Fix:** Store `bcrypt.hash(refreshToken, 8)` in the database column. Compare via `bcrypt.compare()` during token refresh.

---

### M-07 — FCM Token Printed to Device Log in Production Mobile Build

| | |
|---|---|
| **File** | `/mobile/lib/core/services/notification_service.dart` |
| **Lines** | 205, 208 |
| **Severity** | MEDIUM |

FCM tokens are printed via `print()`, which writes to the system log accessible to other apps and via ADB.

**Fix:**
```dart
import 'package:flutter/foundation.dart';
if (kDebugMode) debugPrint('FCM Token: $token');
```

---

## Low Issues

### L-01 — CORS Fallback Default Is localhost

| **File** | `/backend/src/main.ts` lines 13-16 |
|---|---|
| **Severity** | LOW |

The fallback `'http://localhost:5173'` is active if `CORS_ORIGIN` env var is unset in production.

**Fix:** Fail at startup if `CORS_ORIGIN` is not set.

---

### L-02 — No Certificate Pinning on Mobile Dio Client

| **File** | `/mobile/lib/core/di/injection.dart` lines 50-60 |
|---|---|
| **Severity** | LOW |

The Dio client has no certificate pinning. HTTPS traffic can be intercepted on compromised networks.

**Fix:** Configure certificate pinning or use `dio_certificate_pinning` package.

---

### L-03 — IP Address and User-Agent Not Captured in Audit Logs

| **File** | `/backend/src/modules/users/users.service.ts` |
|---|---|
| **Severity** | LOW |

`AuditService` supports `ipAddress` and `userAgent` fields, but all calls pass `undefined`.

**Fix:** Use a NestJS interceptor to extract `req.ip` and `req.headers['user-agent']`.

---

### L-04 — Duplicate Weak ChangePasswordDto in auth.controller.ts

| **File** | `/backend/src/modules/auth/auth.controller.ts` lines 41-48 |
|---|---|
| **Severity** | LOW |

A local `ChangePasswordDto` uses `@MinLength(6)` while `auth/dto/login.dto.ts` defines the same class with `@MinLength(8)` and complexity regex. Controller uses the weaker version.

**Fix:** Delete the inline class and import from `./dto/login.dto.ts`.

---

### L-05 — attachmentUrl Field on Leave Requests Accepts Arbitrary Strings

| **File** | `/backend/src/modules/leaves/dto/leave.dto.ts` line 33-36 |
|---|---|
| **Severity** | LOW |

`attachmentUrl` is `@IsOptional() @IsString()` with no URL format validation.

**Fix:** Add `@IsUrl({ require_tld: true, protocols: ['https'] })`.

---

## Good Practices Found

- bcrypt cost factor 12 for password hashing
- `@Exclude()` on `passwordHash` and `refreshToken` entity fields prevents API response leakage
- `ParseUUIDPipe` applied consistently on all path parameters
- `ValidationPipe` with `whitelist: true` and `forbidNonWhitelisted: true` globally applied
- Soft delete implemented for users, leaves, departments, and holidays
- Audit service sanitizes sensitive fields before persisting
- `flutter_secure_storage` used for all token storage on mobile
- 15-minute access token TTL with separate refresh secret and 7-day window
- JWT strategy re-validates user `status === 'active'` on every request
- `@Throttle` rate limiting on both login endpoints (5 per minute)
- Multer file filter + `ParseFilePipe` double-validation on uploads; UUID-based file naming prevents traversal
- TypeORM parameterized queries throughout — no SQL concatenation found
- No `dangerouslySetInnerHTML` found in the React dashboard
- `DASHBOARD_ROLES` check prevents regular employees from accessing the admin panel
- HTTPS enforced on the production API URL in mobile DI configuration

---

## Summary Scorecard

| Category | Score | Notes |
|---|---|---|
| Authentication | 78/100 | Strong bcrypt+JWT; plaintext password in mobile biometric storage |
| Authorization | 82/100 | Comprehensive RBAC; one IDOR in leaves |
| Input Validation | 75/100 | Good DTO coverage; several controllers bypass it |
| API Security | 60/100 | No Helmet; throttler inactive globally; Swagger in production |
| Data Protection | 80/100 | Exclude decorators work; refresh token plaintext in DB |
| Mobile Security | 72/100 | flutter_secure_storage used; no cert pinning; plaintext password |
| Dashboard Security | 85/100 | No XSS vectors; no CSRF surface; token in localStorage acceptable |
| Logging & Audit | 78/100 | Sanitized audit logs; IP/UA missing; FCM token in device log |
| Secrets Management | 88/100 | .env excluded from git; no hardcoded secrets in source |

### Overall Security Score: 72 / 100

**Verdict: CONDITIONAL PASS**

Safe for current internal use. The High and Medium issues — especially H-01 (plaintext password in secure storage), H-02 (Swagger in production), M-01 (global throttler guard missing), and M-02 (no Helmet) — should be resolved before any production scope expansion.
