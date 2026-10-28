# Fullup — Documentation Guide

Unified documentation for all apps in the Fullup monorepo.

## Apps

| App | Description |
|-----|-------------|
| `apps/corp` | Corporate/Company app |
| `apps/delivery` | Delivery app |
| `apps/individuals` | Client & vehicle-driver app (individuals + drivers) |
| `apps/pay` | Payment app |
| `apps/provider` | Service provider app |
| `apps/worker` | Worker app |

## Shared Packages

| Package | Purpose |
|---------|---------|
| `packages/core/auth` | Authentication logic |
| `packages/core/models` | Shared data models & entities |
| `packages/core/networking` | Dio client, interceptors |
| `packages/core/storage` | Local & secure storage |
| `packages/core/wallet` | Wallet/payment logic |
| `packages/localization` | Translations & locale support |
| `packages/maps` | Map integration |
| `packages/notifications` | Push notifications |
| `packages/ui_kit` | Shared widgets, theme, extensions |
| `packages/utils` | Formatters, helpers, validators |

---

## Documentation Files

| Need to... | Check this |
|------------|------------|
| Understand architecture & folder structure | [architecture.md](architecture.md) |
| Know coding standards & rules | [coding_rules.md](coding_rules.md) |
| Implement a new feature step-by-step | [feature_guide.md](feature_guide.md) |
| Set up a new app in the monorepo | [new_app_checklist.md](new_app_checklist.md) |
| Implement real-time chat | [guides/chat_implementation.md](guides/chat_implementation.md) |
| Add device search indexing | [guides/device_search_indexing.md](guides/device_search_indexing.md) |
| Add rate limiting & throttling | [guides/rate_limiting.md](guides/rate_limiting.md) |
| Add SMS OTP auto-fetch | [guides/sms_auto_fetch.md](guides/sms_auto_fetch.md) |
| Write E2E tests with Maestro | [guides/maestro_e2e_testing.md](guides/maestro_e2e_testing.md) |
| Understand git workflow & branching | [git_workflow.md](git_workflow.md) |
| Write unit/widget/E2E tests | [testing_guide.md](testing_guide.md) |
| Understand CI/CD pipeline | [ci_cd_guide.md](ci_cd_guide.md) |

## Requirements (BRD / SRS)

| App | Markdown | Source |
|-----|----------|--------|
| Worker | [brd/Worker-BRD-V3.md](brd/Worker-BRD-V3.md) — BRD + implementation status + open questions | [brd/Worker-BRD-V3.pdf](brd/Worker-BRD-V3.pdf) |
| Corp | [srs/FullUp-Corp-Mobile-SRS.md](srs/FullUp-Corp-Mobile-SRS.md) (SRS) | [brd/Corp-BRD-V3.pdf](brd/Corp-BRD-V3.pdf) |
| Provider | — | [brd/Provider-BRD-V1.pdf](brd/Provider-BRD-V1.pdf), [srs/FullUp-Provider-Mobile-SRS.docx](srs/FullUp-Provider-Mobile-SRS.docx) |
| Delivery | — | [brd/Delivery-BRD-V3.pdf](brd/Delivery-BRD-V3.pdf) |
| Client & Driver (`apps/individuals`) | [brd/Client-Driver-BRD-V2.md](brd/Client-Driver-BRD-V2.md) — BRD + changes vs old draft + implementation status + open questions | [brd/Client-Driver-BRD-V2.pdf](brd/Client-Driver-BRD-V2.pdf) |
| Pay (NFC) | — | [brd/Pay-NFC-BRD-V3.pdf](brd/Pay-NFC-BRD-V3.pdf) |

---

## Workflow

### Before Starting a New Feature:

1. Check [architecture.md](architecture.md) — understand where code goes
2. Check [coding_rules.md](coding_rules.md) — follow standards
3. Check [feature_guide.md](feature_guide.md) — implement step by step
4. Check relevant guide in `guides/` — for specific patterns

### Key Principles

1. **Clean Architecture** — Presentation → Domain → Data layers
2. **Monorepo** — Shared code in `packages/`, app-specific in `apps/`
3. **State Management** — BLoC for complex flows, Cubit for simple state
4. **Dependency Injection** — getIt + injectable
5. **Navigation** — go_router
6. **Bilingual** — Arabic (primary) + English with RTL support
7. **Feature-First** — Organize by features, not by technical layers
