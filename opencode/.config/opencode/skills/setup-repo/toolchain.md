# Toolchain: Taskfile, Worktrunk, CI

The repo's commands live in one place, and every runner uses them:

```
Taskfile.yml          ← single source of truth: commands, env vars, build tags
  ↑         ↑        ↑
agents   .config/wt.toml   .github/workflows
         (hooks)           (CI jobs)
```

When an agent, a worktree hook, and CI all call the same task, "passes locally" means "passes in CI". Every drift from this shape is a finding.

## Taskfile.yml

- Every task has a `desc`, so `task --list` is the command reference. No separate commands doc.
- Env vars the toolchain needs (`CGO_ENABLED`, build tags, compiler flags) live on the task or in the top-level `env:`/`vars:`. A command that only works with an env var set by hand is broken.
- Secrets are loaded by the task from the secret store (e.g. `gopass`), never pasted into the Taskfile. Name every required secret in the task's `desc` or a comment above it. Tasks run non-interactively: a locked store or missing secret fails fast with a message naming the fix, never a prompt or a hang.
- Generated or embedded assets a fresh checkout lacks get a `setup` (or `ci:prepare`) task, and every task that needs them depends on it. Generated output is fully gitignored; partly tracked output causes dirty trees and merge conflicts.
- Any command an agent needs repeatedly gets a task, including cross-builds and platform tests. A workaround that lives only in session history gets reinvented every session.

Canonical tasks. Use the names the repo already has; add only what is missing:

| Task | Runs | Called by |
| --- | --- | --- |
| `setup` | install deps, generate code and assets on a fresh checkout | `post-start` hook, CI first step |
| `check` | fast checks: format, lint, typecheck | `pre-commit` hook |
| `test` | the test suite with every required env var and tag | agents, `ci` |
| `ci` | exactly what CI runs on Linux: `setup`, `check`, `test`, build | `pre-merge` hook, CI job |
| `dev` | the dev server or app | humans |

Platform-specific CI jobs (e.g. Windows) get their own `ci:<platform>` task with `platforms:` set.

## .config/wt.toml

```toml
# Fresh worktree is runnable before an agent starts.
[pre-start]
setup = "task setup"

# Fast feedback on every wt commit/squash.
[pre-commit]
check = "task check"

# Merge gate: identical to the CI job.
[pre-merge]
ci = "task ci"
```

- Prefer `pre-start` for `setup`: an agent dispatched right after `wt switch --create` needs it finished. Use `post-start` only for slow, optional work (warming caches with `wt step copy-ignored`).
- After editing hooks, the user re-approves them: `wt config approvals add`. Unapproved hooks are skipped, silently skipping the checks.
- Verify with `wt hook show` and `wt hook pre-merge` in a fresh worktree.

## CI workflows

- Each job installs the toolchain, then calls one task (`task ci`, `task ci:windows`). Job steps that run raw commands are drift: move them into the Taskfile.
- Install `task` in CI with `go-task/setup-task` (or the repo's existing method).
- If CI runs a platform the dev host can reach (WSL runs Windows `.exe` files through `powershell.exe`), add a `test:<platform>` task that builds and runs the tests there, and call it from `ci`. If the platform is unreachable, say so in the CI task's `desc`, so an agent knows `gh pr checks` is the only gate for it.
