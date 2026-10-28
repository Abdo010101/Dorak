# Git Workflow & Branching Strategy

## Branch Structure

```
main              ← Production. Never push directly.
  │
develop           ← Integration. All features merge here.
  │
  ├── feature/auth-login        ← One feature per branch
  ├── feature/vehicles-crud
  ├── fix/otp-countdown
  └── chore/update-deps
```

## Branch Naming

| Prefix | Use When |
|--------|----------|
| `feature/` | New feature: `feature/auth-login`, `feature/vehicles-crud` |
| `fix/` | Bug fix: `fix/otp-countdown`, `fix/wallet-balance` |
| `refactor/` | Code refactor: `refactor/extract-validators` |
| `chore/` | Maintenance: `chore/update-deps`, `chore/ci-config` |
| `release/` | Release prep: `release/v1.0.0` |

## Daily Workflow

### Starting a Feature

```bash
# 1. Switch to develop and get latest
git checkout develop
git pull origin develop

# 2. Create feature branch
git checkout -b feature/auth-login

# 3. Code your feature...

# 4. Commit (small, frequent commits)
git add .
git commit -m "feat: add login screen UI"

# 5. Push to remote
git push origin feature/auth-login

# 6. Open PR to develop on GitHub
```

### Updating Your Branch (Do This Daily)

```bash
# While on your feature branch
git pull origin develop
# Resolve conflicts if any
git push origin feature/auth-login
```

### After PR Approved

```bash
# Merge via GitHub (Squash and Merge recommended)
# Then update local
git checkout develop
git pull origin develop
# Delete old branch
git branch -d feature/auth-login
```

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <short description>

<body (optional)>
```

### Types

| Type | When |
|------|------|
| `feat:` | New feature: `feat: add login screen` |
| `fix:` | Bug fix: `fix: OTP countdown not resetting` |
| `refactor:` | Code change (no new feature/fix): `refactor: extract phone validator` |
| `style:` | Formatting only: `style: format auth files` |
| `test:` | Add/fix tests: `test: add login bloc tests` |
| `chore:` | Maintenance: `chore: update dio to 5.8.0` |
| `docs:` | Documentation: `docs: update architecture guide` |

### Examples

```bash
# Good
git commit -m "feat: add vehicle list with search and filter"
git commit -m "fix: wallet charge amount validation for zero"
git commit -m "test: add auth bloc unit tests"

# Bad
git commit -m "update"
git commit -m "fix stuff"
git commit -m "wip"
```

## Pull Request Rules

### Before Opening PR

- [ ] `flutter analyze` — no errors
- [ ] `dart format .` — all formatted
- [ ] `flutter test` — all tests pass
- [ ] Branch is up to date with `develop`
- [ ] Only your feature files changed (no unrelated changes)

### PR Template

```markdown
## What
- Added login screen with phone + password

## Why
- REQ-02: Users need to authenticate

## How to Test
1. Launch app
2. Enter phone: 0501234567
3. Enter password: TestPass1
4. Should navigate to home

## Screenshots
[Attach if UI change]
```

### PR Review Checklist (for reviewer)

- [ ] Code follows architecture (clean arch layers)
- [ ] No business logic in widgets
- [ ] No direct API calls in UI
- [ ] Bloc/Cubit has tests
- [ ] Strings are localized (no hardcoded text)
- [ ] Error states handled
- [ ] Loading states handled
- [ ] Empty states handled
- [ ] RTL layout checked
- [ ] No `print()` statements (use logger)
- [ ] No commented-out code

## Feature Assignment

Split by module — each dev owns full vertical slice:

```
Dev 1:                           Dev 2:
─────────────                    ──────────────────
feature/auth-login               feature/vehicles-crud
feature/auth-register            feature/drivers-crud
feature/auth-otp                 feature/maintenance
feature/wallet                   feature/orders-create
feature/settings                 feature/orders-tracking
feature/support-tickets          feature/maps
feature/subscriptions            feature/store-checkout
feature/points                   feature/invoices
feature/branches                 feature/brands-cards
```

### Conflict Prevention

| Rule | Why |
|------|-----|
| One feature = one branch | No mixing work |
| Pull `develop` daily | Stay current |
| Small PRs (< 20 files) | Easy review, less conflict |
| Don't edit shared packages without telling teammate | WhatsApp message first |
| Merge PR same day | Don't let branches go stale |

### If Conflict Happens

```bash
# On your feature branch
git pull origin develop
# VS Code shows conflicts
# Fix each file (keep both changes or pick one)
git add .
git commit -m "fix: resolve merge conflict with develop"
git push origin feature/your-branch
```

## Release Flow

```bash
# All R1 features merged to develop and tested
git checkout main
git pull origin main
git merge develop
git tag v1.0.0
git push origin main --tags
# CI builds Android + iOS
```

## Protected Branch Rules (Set in GitHub)

Go to GitHub → Settings → Branches → Add rule:

### `main` branch:
- [x] Require PR before merging
- [x] Require 1 approval
- [x] Require status checks to pass (CI)
- [x] No direct push

### `develop` branch:
- [x] Require PR before merging
- [x] Require status checks to pass (CI)
- [ ] Approval optional (2 devs = trust each other)
