---
name: fullup-feature
description: Run the full Fullup agentic pipeline for one feature — requirements → task definition → Tech Lead approval → Coder → gates → Reviewer + Tester in parallel → fix loop → report. Use when the user asks to build, implement or add a feature or screen in a Fullup app.
argument-hint: <app> <feature> [BRD § / REQ ids / Figma link]
---

# /fullup-feature — full pipeline

Task: **$ARGUMENTS**

You are the orchestrator. The user is the Tech Lead: they approve the task definition
and read the final report. You run everything in between without stopping to ask.
Subagents cannot spawn subagents, so every agent is launched from here.

## 0. Preflight

- Resolve the app (`apps/<app>`) and feature name from the arguments. If the app is
  missing or ambiguous, ask once.
- `git status --short` and `git branch --show-current`.
  - Clean tree on `develop`: `git switch -c feature/<app>-<feature>`.
  - Already on a `feature/*` branch for this work: stay.
  - Uncommitted changes on another branch: do **not** switch, stash or restore
    (parallel sessions share this tree). Tell the user and continue on the current
    branch only if they say so.

## 1. Requirements

Read the app's requirements for this feature (table in the `fullup-conventions`
skill): the BRD/SRS sections, their business rules and acceptance criteria. Read the
Figma node when a link was given. Skim the closest existing feature in the app and
`packages/features/*` / `packages/ui_kit` for what can be reused.

## 2. Task definition — approval gate

Write the task definition:

```
## Task: <App> — <Feature>
**Objective:** one sentence
**Input:** BRD/SRS §, Figma screens, API endpoints (or "mock data source")
**Screens / files:** what will be created or changed
**Acceptance criteria:** measurable checklist
**Business rules:** each with its § / BR-xx / REQ-xx
**Edge cases:** failure and boundary behaviour
**Reuse:** ui_kit widgets and shared packages to use
**Not in scope:** what this task does not cover
**Open questions:** gaps in the requirements, with the assumption you will make
```

Keep one task under roughly 20 changed files. If it is bigger, split it into ordered
tasks and run the pipeline once per task.

Show it to the user and wait for approval. This is the only planned stop. Apply
their edits and carry on.

## 3. Code

Launch `fullup-coder` with the approved task definition verbatim, the app and feature
paths, and the reuse list. Wait for its report.

## 4. Gates

Run yourself, on the files the Coder listed:

```bash
dart format <changed files>
flutter analyze apps/<app>
```

Analyzer issues in changed files go back to the Coder before review.

## 5. Review and test — in parallel

Launch both in one message:

- `fullup-reviewer` — the task definition and the list of changed files.
- `fullup-tester` — the task definition, changed files and the Coder's "For the Tester" notes.

Give each the code and the requirements, not your opinion of the code.

## 6. Fix loop

If the Reviewer says CHANGES REQUIRED (any blocker or major) or the Tester reports
FAIL / defects:

1. Send the findings and defects, unedited, to `fullup-coder` (continue the same
   agent so it keeps its context).
2. Re-run the gates.
3. Re-run `fullup-tester` to run the suite, and `fullup-reviewer` on the changed
   files, telling it which findings were addressed.

At most **2 fix rounds**. If blockers remain after that, stop and report them: the
Tech Lead decides. Minor findings are listed in the report, not looped on.

## 7. Report

```
## <App> — <Feature>: READY FOR PR | NEEDS DECISION
Branch: feature/<app>-<feature>

**Built** — acceptance criteria met / not met
**Requirements covered** — § / BR-xx list
**Files** — n created, n modified (paths)
**Review** — verdict, findings fixed, findings left (with file:line)
**Tests** — passed/total for the feature and the app, analyze result
**Open questions** — what needs a product or backend answer
**Next** — anything the Tech Lead should run by hand (visual check, Maestro)
```

Report what the agents actually returned. If a test fails or a step was skipped, say so.

Also, when the app is Worker: update the implementation status in
`docs/brd/Worker-BRD-V3.md` §92.

## Rules

- No commit, push or PR unless the user asks. When they do: Conventional Commits
  with scope (`feat(delivery): ...`), PR to `develop`, template from
  `docs/git_workflow.md`, cite the BRD §.
- No Maestro or simulator runs: verification is analyze + tests; the user checks visually.
- Never `dart format .`, `git checkout`, `git restore` or `git stash`.
- Never mark the pipeline green on an agent's word alone when you can run the
  command: re-run `flutter test` for the feature (from inside `apps/<app>`) before the final report.
- Failures that existed before the task are listed separately as pre-existing, not
  blamed on the feature and not silently ignored.
