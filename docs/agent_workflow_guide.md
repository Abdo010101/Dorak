# FullUp Agent Workflow Guide
## How to Work with AI Agents Across All FullUp Projects

**Version:** 2.0
**Date:** 2026-10-04
**Scope:** All FullUp Mobile Applications
**Owner:** Web Study Development Team

> **Running the pipeline:** the flow in this guide is automated. Type
> `/fullup-feature <app> <feature>` and the Coder, Reviewer and Tester agents run it.
> See [§13 Agentic Flow](#13-agentic-flow).

---

## 1. Project Overview

FullUp is a multi-app ecosystem in one monorepo. Each app follows the same development pipeline:

| # | App | Folder | Target User | Code status |
|---|-----|--------|------------|-------------|
| 1 | Full Up Worker | `apps/worker` | Station workers | Active — 11 features |
| 2 | Full Up Delivery | `apps/delivery` | Delivery drivers (multi-product) | Active — 10 features |
| 3 | Full Up Corp | `apps/corp` | Companies (fleet mgmt) | Scaffold — `core/` only, no features yet |
| 4 | Full Up Pay | `apps/pay` | Fuel/electronic payments (NFC) | Stub |
| 5 | Full Up Provider | `apps/provider` | Merchants/providers | Stub |
| 6 | Full Up Individuals | `apps/individuals` | Individual clients + vehicle drivers (one app, two flows) | In progress |

Shared across apps: `packages/features/{auth,chat,notifications,profile,settings}`, `packages/ui_kit`, `packages/core/*`.

**Tech Stack:** Flutter (Dart), pub workspaces monorepo (root `pubspec.yaml`), iOS + Android, Arabic RTL + English LTR + Urdu, Light/Dark mode, Unified Backend/APIs.

---

## 2. Development Pipeline

Every feature follows this flow — no exceptions:

```
BRD (Business) → SRS (Technical) → Implementation → Review → Test → Release
```

### 2.1 Pipeline Stages

| Stage | Input | Output | Agent Model | Human Role |
|-------|-------|--------|-------------|------------|
| BRD Analysis | BRD PDF | Feature breakdown | Opus | Verify completeness |
| SRS Writing | BRD + Figma | SRS document (IEEE 29148) | Opus | Review + approve |
| SRS Quality Check | SRS document | Score ≥90% | Opus | Final sign-off |
| Work Splitting | SRS | Task list with acceptance criteria | Opus | Validate priorities |
| UI Implementation | SRS + Figma | Flutter screens | Sonnet | Review RTL/LTR, UX |
| Business Logic | SRS | Dart services/blocs | Opus | Verify business rules |
| API Integration | SRS + API docs | Repository layer | Sonnet | Check error handling |
| Unit Tests | SRS acceptance criteria | Test files | Sonnet | Verify coverage |
| Code Review | Implementation | Review findings | Opus | Act on findings |
| Localization | SRS | ARB files (AR/EN/UR) | Sonnet | Native speaker check |

---

## 3. Agent Model Selection Guide

### 3.1 When to Use Opus (Complex Reasoning)

- SRS document generation
- Business logic with complex rules (order concurrency, route optimization, NFC lifecycle)
- State management design (order state flow, NFC status lifecycle)
- Code review (catch subtle bugs, security issues)
- Architecture decisions
- Multi-step workflows with branching logic
- Anything involving Arabic business domain understanding

### 3.2 When to Use Sonnet (Fast, Pattern-Based)

- UI screen implementation from Figma
- API integration (REST calls, model parsing)
- Unit test generation
- Localization/translation files
- Simple CRUD operations
- Boilerplate code (models, repositories, routes)
- Documentation formatting

### 3.3 When to Use Haiku (Quick, Lightweight)

- Code formatting fixes
- Simple refactoring (rename, extract method)
- Generating JSON fixtures/mock data
- Syntax questions
- Simple file operations

### 3.4 Decision Matrix

```
Is the task ambiguous or has complex business rules?
  YES → Opus
  NO → Does it need creativity or architecture design?
    YES → Opus
    NO → Is it pattern-based or repetitive?
      YES → Sonnet
      NO → Is it trivial?
        YES → Haiku
        NO → Sonnet
```

---

## 4. Spec Writing Standards

### 4.1 BRD → SRS Conversion Rules

- SRS for **mobile apps only**, NOT dashboards
- Follow IEEE 29148 structure
- Apply SRS Quality Framework V2 (target ≥90%)
- Every SRS requirement must trace back to BRD section
- Include acceptance criteria for every functional requirement

### 4.2 Agent Prompt Template for SRS

```
Context: FullUp [App Name] - [Feature Name]
Source: BRD Section [X] to [Y]
Standard: IEEE 29148, SRS Quality Framework V2

Task: Generate SRS for [feature].

Constraints:
- Mobile app only (iOS/Android)
- Arabic RTL + English LTR + Urdu
- Light/Dark mode support
- All data from Unified Backend/APIs
- Product-agnostic design (not fuel-only)
- Include: functional requirements, non-functional, 
  business rules, acceptance criteria, screen list
```

### 4.3 Task Definition Template

When splitting work for agents:

```
## Task: [Feature] - [Specific Task]

**Objective:** [One sentence]

**Input:** [SRS section, Figma screen, API endpoint]

**Acceptance Criteria:**
- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [Measurable criterion 3]

**Business Rules:**
- [Rule from BRD/SRS]

**Edge Cases:**
- [What happens when X fails]

**Not In Scope:**
- [What this task does NOT cover]
```

---

## 5. Guardrails

### 5.1 Code Quality Gates

| Gate | Tool | When | Blocks PR? |
|------|------|------|-----------|
| Lint | `flutter analyze` | Every commit | Yes |
| Format | `dart format` | Every commit | Yes |
| Tests | `flutter test` | Every PR | Yes |
| Coverage | lcov | Every PR | R1 > 70%, R2 > 80%, R3 > 85% |
| Localization | check missing keys | Every PR | Yes |
| RTL check | manual + automated | Every screen PR | Yes |

### 5.2 Business Rule Validation Checklist

Before accepting agent output for business logic:

- [ ] All BRD business rules implemented (cross-reference by ID)
- [ ] Concurrency rules enforced (atomic operations where BRD specifies)
- [ ] Backend is source of truth (no local calculations for prices/taxes/permissions)
- [ ] Error states handled (no internet, API failure, timeout, session expired)
- [ ] Audit log events sent for sensitive operations
- [ ] Data minimization applied (driver sees only their data)
- [ ] Geofence/location rules enforced where applicable
- [ ] Status lifecycle respected (no skipping states)

### 5.3 Security Checklist

- [ ] HTTPS for all communication
- [ ] Tokens stored securely (not SharedPreferences plain text)
- [ ] OTP not cached/stored locally
- [ ] Rate limiting on sensitive endpoints
- [ ] Session expiration handled
- [ ] Sensitive data cleared on logout
- [ ] No hardcoded secrets in code
- [ ] API authorization checked per request

### 5.4 UI/UX Checklist

- [ ] Arabic RTL layout correct
- [ ] English LTR layout correct
- [ ] Urdu layout correct (where applicable)
- [ ] Light mode renders correctly
- [ ] Dark mode renders correctly
- [ ] All strings externalized (no hardcoded text)
- [ ] Responsive across screen sizes
- [ ] Loading states shown
- [ ] Error states shown with localized messages
- [ ] Empty states handled

---

## 6. Review Process

### 6.1 Agent Output Review Framework

```
Level 1 — Automated (CI)
  └── lint, format, tests, coverage

Level 2 — Agent Review (Opus)
  └── Code review prompt with checklist
  └── Security scan
  └── Business rule verification

Level 3 — Human Review (You)
  └── Does it match SRS?
  └── Business logic correct?
  └── UX makes sense?
  └── Edge cases covered?
  └── Would I ship this?
```

### 6.2 Code Review Prompt for Agent

```
Review this code for FullUp [App Name].

Check against:
1. SRS requirement [REQ-XXX]: [description]
2. Business rules: [list from BRD]
3. Security: tokens, OTP, session, data protection
4. Error handling: offline, timeout, API failure
5. RTL/LTR correctness
6. State management: no invalid state transitions
7. Backend dependency: no local price/tax calculations

Report format: file:line — severity — issue — fix
```

---

## 7. Common Patterns Across All FullUp Apps

### 7.1 Authentication (shared across all 7 apps)

```
Language Selection → Country Selection → Login (Phone/Email) → 
OTP Verification → Home

Rules:
- OTP via SMS or WhatsApp (user choice on resend)
- Rate limiting on OTP
- Change phone number invalidates previous OTP
- OTP expiry from Backend
- Biometric login (Face ID / Fingerprint) after first login
```

### 7.2 Profile Management (shared)

```
- Profile photo (editable)
- Name (editable per permissions)
- Phone (per system policy)
- Email (per permissions)
- Country (read-only or per permissions)
- Password change
```

### 7.3 Settings (shared)

```
- Language (AR/EN/UR) — no data loss on change
- Theme (Light/Dark) — all components support both
- Notifications (on/off)
- Quick login (biometric)
- App updates (mandatory/optional from Backend)
- Logout (confirmation dialog, clear session + local sensitive data)
- Privacy policy, Terms & Conditions
```

### 7.4 Notifications (shared)

```
- Push notifications (FCM)
- In-app notification list (All/Read/Unread tabs)
- Unread = red background, Read = white
- Date + Time shown
- Tap to open details + mark as read
```

### 7.5 Support (shared)

```
- Create ticket (title, category, description, attachments)
- Ticket statuses: New → Open → In Progress → Pending → Resolved → Closed
- Reply on ticket
- Close ticket
```

### 7.6 Internet Handling (shared)

```
- No Internet → show clear message
- Weak Network → handle without freezing
- API Failure → show error
- Timeout → retry
- Session Expired → re-authenticate
- Request Failed → don't count as success
- Backend Confirmation = source of truth for all operations
```

---

## 8. Product-Agnostic Design Rule

**Critical for Delivery App and any multi-product app:**

Apps must NOT be designed for one product only. Workflow must be unified and extensible.

Current products: Fuel, Oils, Tires, Batteries, Vehicle Care, Wash, NFC Chips.

```
Product properties come from Backend Configuration:
- Product name, type, brand
- Unit, quantity rules
- Price, cost, VAT
- Delivery workflow steps
- QR/verification requirements
- Partial return rules

App renders dynamically based on product config.
Adding new product = Backend config change, NOT app redesign.
```

---

## 9. App-Specific Agent Instructions

### 9.1 Delivery App Agent Context

```
You are working on FullUp Delivery Application.
Target user: Delivery drivers.
Platform: iOS + Android (Flutter).
Languages: Arabic (RTL), English (LTR), Urdu.
Theme: Light + Dark mode.

Core workflow:
Login → Online (geofence check) → Receive orders → 
Accept/Reject → Route (nearest-first optimization) → 
Navigate → Arrive → Execute delivery → QR verify → 
Partial return (if needed) → Complete → Update reports

Key business rules:
- Driver must be Online + inside geofence to receive orders
- Order acceptance is atomic (backend lock, no duplicate acceptance)
- Route optimization: nearest-first from driver current location
- Location is current (not live tracking) — refreshed on map open
- QR verification from client phone for delivery confirmation
- Return quantity cannot exceed ordered quantity
- Prices/taxes/refunds calculated by Backend only
- All sensitive operations logged in audit trail

Products supported: Fuel, Oils, Tires, Batteries, Vehicle Care, Wash, NFC Chips.
Product properties are dynamic from Backend.
```

### 9.2 Driver NFC App Agent Context

```
You are working on FullUp Driver Assign NFC to Client Feature Application.
Target user: Drivers assigned to activate NFC chips at client locations.
Platform: iOS + Android (Flutter).
Languages: Arabic (RTL), English (LTR), Urdu.
Theme: Light + Dark mode.

Core workflow:
Login → Home → Activate NFC → Scan/Manual Entry → 
Verify chip (exists, status, vehicle, driver permission) → 
Display chip + vehicle data → Activate → Backend validation → 
Update status → Audit log → Success → Activate another

Key business rules:
- 1 NFC chip = 1 vehicle (one-to-one, strictly enforced)
- Chip lifecycle: New → Assigned → Ready for Activation → Activated → Blocked/Cancelled
- Driver cannot skip states or modify chip-vehicle assignment
- Pre-activation validation: chip exists, not already activated, 
  linked to one vehicle, driver has permission
- All activations logged with: user, driver, NFC ID, vehicle, 
  operation type, status, timestamp, device info, IP
- Camera permission for scanner, with manual entry fallback
```

### 9.3 Corp App Agent Context

```
You are working on FullUp Corp Application.
Target user: Companies managing vehicle fleets.
Platform: iOS + Android (Flutter).
Languages: Arabic (RTL), English (LTR).
Theme: Light + Dark mode.

Core workflow:
Register (3-step + admin approval) → Login → Dashboard →
Manage Fleet (vehicles, drivers, maintenance, licenses) →
Place Orders (petroleum/non-petroleum) → Track on Map →
Receive Invoice (ZATCA) → Manage Wallet → Reports

13 Modules (REQ-01 to REQ-118):
M-01 Registration & Accounts | M-02 Home & Wallet |
M-03 Vehicle Management | M-04 Orders & Tracking |
M-05 Smart Verification, Cards & Brands |
M-06 Store, Purchases & Invoices |
M-07 Reports, Activities & Notifications |
M-08 Support Tickets | M-09 Maps & Locations |
M-10 Settings & Quick Login | M-11 Subscriptions |
M-12 Full Up Points (P2) | M-13 Branch Management

Key business rules:
- Admin approval required before first login
- Editing company data triggers re-approval
- Plate number immutable after vehicle creation
- Suspending driver blocks new orders for that driver
- ZATCA-compliant invoices: QR code, 15% VAT, PDF download
- Wallet: manual charge + electronic charge (payment gateway)
- Discount coupons at charge or purchase
- Real-time order tracking via WebSocket (<3s updates)
- Verification groups: auto-match vehicles by criteria
- Brands linked to vehicles — blocked brand hidden from drivers
- Soft delete pattern for all deletions
- OTP: 4-digit, 1min expiry, 30s resend cooldown
- JWT 8h validity, 30min session timeout

Navigation: Home | Orders | Map | More

Entity model:
Company (1) → (N) Vehicle → (0..1) Driver
Company (1) → (1) Wallet → (N) WalletTransaction
Company (1) → (N) Order → (0..1) Invoice
Vehicle (N) ↔ (N) Brand [via VehicleBrand]
```

### 9.4 Provider App Agent Context

```
You are working on FullUp Provider Application.
Target user: Merchants/providers (station owners, delivery centers).
Platform: iOS + Android (Flutter). Mobile-first (smartphones only).
Languages: Arabic (RTL), English (LTR).
Theme: Light + Dark mode.

Nature: Mobile extension of Provider Dashboard — same data,
same business rules, same permissions, same approval workflow.
NOT a standalone app.

Core workflow:
App Launch → Language → Auth → Login/Register → OTP →
Account Verification → Dashboard → Operations →
Orders/Stations/Centers → Products/Services →
Order Execution → Sales → Wallet → Settlement →
Reports/Invoices → Analytics → Performance

22 Domains:
Account & Profile | Auth | Stations | Delivery Centers |
Employees & Supervisors | Products, Services & Packages |
Promotions | Orders | Wallet | Settlements | Invoices |
Reports | Analytics | Ratings | Warranty |
Blacklist & Reports | Support | Notifications |
Maps & Tracking | Settings & Permissions |
Security & Audit | FAQ

Key business rules:
- Dashboard mirror — app reflects provider web dashboard exactly
- RBAC — features visible based on user permissions only
- Approval workflow — sensitive operations need approval chain
- Screenshot/recording prevention on sensitive screens
- Audit log for all sensitive operations
- Export: Excel (reports), PDF (financial docs)
- Auth: phone login, email login, OTP, biometric/PIN quick login
- Resume existing registration request (not just new)
- Financial: balance, transactions, settlements, monthly invoices
- Employee management with supervisor hierarchy
- Product catalog: products, services, packages, promotions
- Ratings: per-location and per-employee
- Warranty tracking for products
```

### 9.5 Worker App Agent Context

```
You are working on FullUp Worker Application.
Target user: Fuel-station workers; Station Supervisors get extra powers.
Platform: iOS + Android (Flutter).
Languages: Arabic (RTL), English (LTR), Urdu.
Theme: Light + Dark mode.
Requirements: docs/brd/Worker-BRD-V3.md (status in §92, open questions in §93).

Core model (§5, §91):
Verify → Authorize → Fuel/Service → Record → Confirm → Audit

Core workflow (§6):
Language → Country → Login (phone or email) → OTP → Dashboard →
Service request → Plate photo (when required) → Choose verification →
Verify → Vehicle + transaction data → Start fueling/service →
PIN (when requested) → Record actual quantity + price → Pump photo →
Confirm → Summary → Dashboard refresh

Modules:
Authentication | Dashboard | Orders | Transaction details | Refund |
Verification (Trust Check, Plate, Driver ID, QR, NFC) | Fueling |
Reports | Export (.xlsx) | Employees (supervisor) | Complaints |
Notifications | Profile | Settings | Support / FAQ | Audit

Key business rules:
- Products: fuel, oils, tires, batteries, wash, car care — not fuel-only
- Vehicle/driver verified before any service
- Refund: full or partial, inside the refund window only,
  unauthorized refunds blocked by supervisor PIN
- Every transaction linked to worker, station, vehicle, driver, product
- Actual quantity, unit price and total recorded; server confirms
- Features visible by role (permission matrix §4.2)
- Sensitive operations and changes written to the audit log
- Fast UX for a busy forecourt
```

---

## 10. Continuous Improvement

After each feature completion:

1. **What went well?** — Keep doing
2. **What agent got wrong?** — Add to guardrails
3. **What was missing from spec?** — Improve SRS template
4. **What took too long?** — Better task splitting next time
5. **New pattern discovered?** — Add to shared patterns (Section 7)

---

## 11. File References

| Document | Location |
|----------|----------|
| Corp BRD V3 | `docs/brd/Corp-BRD-V3.pdf` |
| Corp SRS | `docs/srs/FullUp-Corp-Mobile-SRS.md` |
| Delivery BRD V3 | `docs/brd/Delivery-BRD-V3.pdf` |
| Client & Driver BRD V2 | `docs/brd/Client-Driver-BRD-V2.pdf` — markdown + implementation status: `docs/brd/Client-Driver-BRD-V2.md` |
| Pay (NFC) BRD V3 | `docs/brd/Pay-NFC-BRD-V3.pdf` |
| Provider BRD V1 | `docs/brd/Provider-BRD-V1.pdf` |
| Provider SRS | `docs/srs/FullUp-Provider-Mobile-SRS.docx` |
| Worker BRD V3 | `docs/brd/Worker-BRD-V3.pdf` — markdown + implementation status: `docs/brd/Worker-BRD-V3.md` |
| Platform mind map | `docs/brd/FullUp-MindMap.pdf` |
| Corp Figma (System 01) | `figma.com/design/9hCSiG7ARXrhmUuDzRJy9V/Full-Up-System--01-` |
| Corp Dashboard Figma (System 02) | `figma.com/design/cgXlLUmG6qIoNgz2wfBhTc/Full-Up-System--02-` |
| Agents | `.claude/agents/` |
| Skills + pipeline commands | `.claude/skills/` |

Not in the repo yet: SRS Quality Framework V2 and the NFC SRS (ask the team lead for the files).

---

## 12. Quick Reference Card

```
START NEW FEATURE:
  /fullup-feature <app> <feature> [BRD § / REQ ids / Figma link]

  1. Agent reads BRD/SRS section, writes task definition
  2. YOU approve the task definition          ← Tech Lead gate
  3. Coder implements (UI first, mock data source)
  4. Gates: dart format + flutter analyze
  5. Reviewer + Tester run in parallel
  6. Fix loop (max 2 rounds)
  7. YOU read the report, check visually, ask for commit / PR

CHECK EXISTING CODE:
  /fullup-review [path | branch] [--fix]

AGENT PROMPT FORMULA:
Context + Source + Constraints + Task + Acceptance Criteria + Edge Cases

REVIEW FORMULA:
Automated (CI) → Agent Review (fullup-reviewer) → Human Review (You)
```

---

## 13. Agentic Flow

The pipeline in §2 runs as a system of skills and subagents inside Claude Code. You
work as Tech Lead: give the task, approve the definition, read the report.

### 13.1 The flow

```
/fullup-feature delivery order-rating §24
        │
        ▼
 1. Requirements      read BRD/SRS §, Figma, existing code
 2. Task definition   §4.3 template
        │
   ══ Tech Lead approves ══
        │
        ▼
 3. fullup-coder      data → domain → logic → UI → route → DI → translations
 4. Gates             dart format (changed files) + flutter analyze
        │
        ├──────────────────────┐
        ▼                      ▼
 5. fullup-reviewer     fullup-tester          (parallel)
    file:line findings     writes + runs tests
        │                      │
        └──────────┬───────────┘
                   ▼
 6. Fix loop     blocker / major / failing test → back to Coder (max 2 rounds)
                   ▼
 7. Report       built, findings, test results, BRD § covered, open questions
```

### 13.2 Subagents (`.claude/agents/`)

| Agent | Model | Does | Never |
|-------|-------|------|-------|
| `fullup-coder` | session model | Implements one approved task definition | Writes tests, edits shared packages unasked, touches git |
| `fullup-reviewer` | Opus | Reviews against requirements, layers, ui_kit, localization, RTL, 4 states, security, code smells. Output: `file:line — severity — issue — fix` | Edits any file |
| `fullup-tester` | Sonnet | Writes and runs cubit / use case / repository / widget tests, reports real results | Edits `lib/`, weakens a test to hide a bug |

Severity: **blocker** (wrong behaviour, broken business rule, security, layer leak),
**major** (enforced convention broken, bug on a rarer path), **minor** (smell).
Blocker and major go through the fix loop; minor is listed in the report.

### 13.3 Skills (`.claude/skills/`)

Knowledge the agents load before working. They describe the code as it is written today.

| Skill | Knows |
|-------|-------|
| `fullup-conventions` | Feature layout, Cubit + Equatable state, use cases, exceptions, mock data source, manual getIt registration, routing, localization, requirements doc per app |
| `fullup-ui-kit` | ui_kit catalog, which widget / style / spacing / icon to use, RTL rules |
| `fullup-testing` | bloc_test + mocktail patterns, test layout and naming, fixtures, run commands |

### 13.4 Commands

| Command | Use |
|---------|-----|
| `/fullup-feature <app> <feature> [§ / REQ / Figma]` | Full pipeline for a new feature or screen |
| `/fullup-review [path \| branch] [--fix]` | Reviewer + Tester on existing code; `--fix` sends findings to the Coder once |

### 13.5 Rules built into the pipeline

- One feature = one branch `feature/<app>-<feature>` off `develop`. The pipeline does
  not switch branches when the tree has uncommitted work.
- No commit, push or PR until you ask.
- Verification is `flutter analyze` + `flutter test`. Visual checks and Maestro stay with the team.
- Formatting touches only changed files (a hook formats each `.dart` file after an
  edit). Never `dart format .` — several sessions share one working tree.
- One task stays under about 20 changed files; bigger work is split at the task-definition step.
- The Reviewer and Tester receive the code and the requirements, never the Coder's
  opinion of its own work.

### 13.6 Your role as Tech Lead

1. **Give the task** with the BRD section or REQ ids when you know them.
2. **Approve the task definition.** This is where scope, business rules and
   assumptions are fixed; a wrong definition gives a wrong feature, correctly built.
3. **Read the report.** Check "Open questions" and "findings left".
4. **Run the app** and check the screens in Arabic, English, Urdu, light and dark.
5. **Ask for the commit / PR.**

### 13.7 Improving the system

After each feature run the §10 retro and put the lesson where the agents will read it:

| Lesson | Put it in |
|--------|-----------|
| Agent broke a code or architecture rule | `.claude/skills/fullup-conventions/SKILL.md` |
| Wrong widget, style or RTL mistake | `.claude/skills/fullup-ui-kit/SKILL.md` |
| Weak or missing tests | `.claude/skills/fullup-testing/SKILL.md` |
| Reviewer missed a class of bug | `.claude/agents/fullup-reviewer.md` → "What to check" |
| Pipeline step in the wrong order or missing | `.claude/skills/fullup-feature/SKILL.md` |

Adding an agent: create `.claude/agents/<name>.md` (frontmatter: `name`,
`description`, `tools`, `model`, `skills`), then add its step to
`.claude/skills/fullup-feature/SKILL.md`. New agents are picked up on the next
Claude Code session.
