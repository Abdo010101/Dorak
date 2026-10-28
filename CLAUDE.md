# CLAUDE.md — dorak-patient

Read this file first every session. It points Claude Code (and any AI agent) to the rules, docs, agents, and skills for this repo.

## Project

- Stack: Flutter (see `pubspec.yaml`).
- Primary branch: `master`. Working branch: `ui-redesign`.
- Remotes: `origin` → Bitbucket `fahmywebstdy/dorak-patient`, `github` → `Abdo010101/Dorak`.
- Push target by default: `github` (see `git_workflow.md`).

## Required reading before any work

Open in this order. Do not skip.

1. [docs/architecture.md](docs/architecture.md) — layer boundaries and folder layout.
2. [docs/coding_rules.md](docs/coding_rules.md) — naming, formatting, lint rules.
3. [docs/feature_guide.md](docs/feature_guide.md) — step-by-step feature flow.
4. [docs/git_workflow.md](docs/git_workflow.md) — branching, commits, PRs.
5. [docs/testing_guide.md](docs/testing_guide.md) — unit, widget, E2E.
6. [docs/mobile_security_policy.md](docs/mobile_security_policy.md) — security rules.
7. [docs/ci_cd_guide.md](docs/ci_cd_guide.md) — pipeline, release.

## Reference docs

- [docs/agent_workflow_guide.md](docs/agent_workflow_guide.md) — AI agent workflow.
- [docs/MCP-AND-WORKFLOWS-GUIDE.md](docs/MCP-AND-WORKFLOWS-GUIDE.md) — MCP + multi-agent.
- [docs/DEVELOPER-OPS-GUIDE.md](docs/DEVELOPER-OPS-GUIDE.md) — dev ops.
- [docs/new_app_checklist.md](docs/new_app_checklist.md) — new app setup.
- [docs/mTLS-Guide.md](docs/mTLS-Guide.md) — mTLS setup.
- [docs/PROJECT-CONTEXT.md](docs/PROJECT-CONTEXT.md), [docs/PROJECT-TASKS.md](docs/PROJECT-TASKS.md), [docs/PROJECT-LOG.md](docs/PROJECT-LOG.md) — project state, backlog, log.
- Audits: [ARCHITECTURE_REVIEW](docs/ARCHITECTURE_REVIEW.md), [SECURITY_AUDIT_REPORT](docs/SECURITY_AUDIT_REPORT.md), [UI_UX_REVIEW](docs/UI_UX_REVIEW.md), [FULL_SYSTEM_REPORT](docs/FULL_SYSTEM_REPORT.md).
- UI specs: [docs/ui/](docs/ui/).
- BRDs/SRS: [docs/brd/](docs/brd/).

## Agents (`.claude/agents/`)

Use via the Agent tool, `subagent_type` = agent file name without `.md`.

- `fullup-coder` — implement a feature or fix.
- `fullup-reviewer` — review a diff or branch.
- `fullup-tester` — write/run tests for changed code.

## Skills (`.claude/skills/`)

Invoke with the Skill tool.

- `fullup-conventions` — repo conventions quick-check.
- `fullup-feature` — scaffold a feature end-to-end.
- `fullup-review` — review checklist.
- `fullup-testing` — testing patterns.
- `fullup-ui-kit` — ui_kit usage.

## Hard rules

1. Flutter: Clean Architecture — Presentation → Domain → Data. No cross-layer imports.
2. State: BLoC for complex flows, Cubit for simple state.
3. DI: `getIt` + `injectable`. No service locators outside DI setup.
4. Nav: `go_router`. No `Navigator.push` in features.
5. i18n: Arabic (primary) + English. Every user-facing string via localization. RTL safe.
6. Feature-first folders, not technical-layer folders.
7. Run `flutter analyze` and `flutter test` before claiming a task done.
8. Format: `dart format` is auto-run on save via `.claude/settings.json` `PostToolUse` hook. Do not fight it.
9. Commits: Conventional Commits. See `docs/git_workflow.md`.
10. Secrets: never commit. Use `--dart-define` or secure storage. See `docs/mobile_security_policy.md`.
11. Push: default remote is `github`. `git push` (upstream already set on `ui-redesign`).

## Workflow

Before coding a feature or fix:

1. Read the four required docs above (architecture, coding_rules, feature_guide, git_workflow).
2. Check `docs/PROJECT-TASKS.md` for the task.
3. Pick the right agent/skill from the lists above.
4. Branch from `master` per `docs/git_workflow.md`.
5. Implement → `flutter analyze` → `flutter test` → commit → push to `github`.
6. Update `docs/PROJECT-LOG.md` with what changed.

## Notes

- `.claude/settings.local.json` is personal to each dev — gitignored. Do not commit.
- Fullup docs (brought from the Fullup monorepo) describe general mobile standards. Dorak-specific overrides live inline in this file; when the two conflict, this file wins.
