# CI/CD Guide

## Pipeline Overview

```
Push / PR to main or develop
         │
         ▼
┌──────────────────┐
│ Step 1: Analyze  │  flutter analyze + dart format
│ (~1 min)         │
└────────┬─────────┘
         │ Pass → continue
         │ Fail → stop, fix code
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌────────┐
│ Test   │ │ Test   │  Parallel
│ Pkgs   │ │ Corp   │  (~3 min)
│        │ │+cover  │
└───┬────┘ └───┬────┘
    │          │
    └────┬─────┘
         │ All pass → continue (if tag)
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌────────┐
│ Build  │ │ Build  │  Only on git tag (v1.0.0)
│ APK    │ │ iOS    │  (~10 min)
└────────┘ └────────┘
```

## What Triggers What

| Action | Analyze | Tests | Build |
|--------|---------|-------|-------|
| Push to `feature/*` | No | No | No |
| PR to `develop` | ✅ | ✅ | No |
| Push to `develop` | ✅ | ✅ | No |
| PR to `main` | ✅ | ✅ | No |
| Push to `main` | ✅ | ✅ | No |
| Tag `v1.0.0` | ✅ | ✅ | ✅ |

## How to Trigger Build

```bash
# Tag a release
git tag v1.0.0
git push origin v1.0.0

# CI builds APK + iOS automatically
# Download from GitHub → Actions → workflow run → Artifacts
```

## GitHub Secrets

Go to GitHub → Repo → Settings → Secrets and Variables → Actions:

| Secret | Value | Used For |
|--------|-------|----------|
| `API_BASE_URL` | `https://api.fullup.corp` | `--dart-define` at build |

## What Fails the Build

| Check | Blocks PR | Blocks Build |
|-------|-----------|-------------|
| `flutter analyze` error | ✅ | ✅ |
| `dart format` violation | ✅ | ✅ |
| Any test fails | ✅ | ✅ |
| Coverage < 70% | ⚠️ Warning | No |
| Build APK fails | — | ✅ |
| Build iOS fails | — | ✅ |

## CI File Location

```
.github/workflows/ci.yml
```

## Adding CI for New App

When building next app (e.g., Individuals), duplicate the `test-corp` job:

```yaml
  test-individuals:
    name: Test Individuals App
    runs-on: ubuntu-latest
    needs: analyze
    steps:
      # Same steps, change paths to apps/individuals
```

## Local Pre-Push Check

Run before pushing to catch issues early:

```bash
# Quick check (30 seconds)
flutter analyze --no-fatal-infos && dart format --set-exit-if-changed . && flutter test

# Or create alias in .zshrc:
# alias fpush="flutter analyze && dart format . && flutter test && git push"
```

## Build Artifacts

After tag push, CI uploads:
- `corp-apk` → APK file for Android testing
- iOS build (no codesign) → verify compilation

Download: GitHub → Actions → Select run → Artifacts section at bottom.
