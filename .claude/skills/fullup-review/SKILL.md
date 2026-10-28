---
name: fullup-review
description: Run the Fullup Reviewer and Tester agents in parallel on existing code — the current diff, a path, or a branch — and return one combined report. Use to check work done outside the /fullup-feature pipeline or before opening a PR.
argument-hint: [path | branch] [--fix]
---

# /fullup-review — review + test existing code

Target: **$ARGUMENTS**

## 1. Scope

- A path (`apps/delivery/lib/features/home`): that feature and its tests.
- A branch name: `git diff develop...<branch> --name-only`.
- Nothing given: uncommitted changes plus `git diff develop...HEAD --name-only`.

Work out the app and feature(s) from the paths. If the scope is empty, say so and stop.
Find the requirements section for the feature (table in the `fullup-conventions`
skill) and pass its reference along.

## 2. Run both agents in one message

- `fullup-reviewer` — the scope and the requirements reference.
- `fullup-tester` — the scope: fill gaps in test coverage for the cubits, use cases
  and repository impls in it, then run the suite.

## 3. Report

```
## Review: APPROVE | CHANGES REQUIRED   ·   Tests: PASS | FAIL

**Findings** (file:line — severity — issue — fix), most severe first
**Defects found by tests**
**Tests** — written, passed/total, analyze result
**Requirements coverage**
**Not checked**
```

Relay the agents' findings as they are. Do not drop, soften or add findings.

## 4. `--fix`

Only when `--fix` was passed: send blocker and major findings plus test defects to
`fullup-coder`, re-run `dart format` on the changed files and `flutter analyze`, then
re-run the Tester and report what was fixed and what is left. One round.

Without `--fix`, change nothing in `lib/`.

## Rules

No commit or push. No Maestro or simulator. Never `dart format .`, `git checkout`,
`git restore` or `git stash`.
