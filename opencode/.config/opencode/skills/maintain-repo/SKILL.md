---
name: maintain-repo
description: "Review a coding session and fix the repo's agent environment: toolchain drift, missing checks, steering files."
disable-model-invocation: true
---

The user has asked you to **maintain** the repo. You are improving the coding agent's **environment** so future runs avoid the friction this session hit. Every finding names a concrete change; the user picks which ones you make.

## Steps

1. Call the Skill tool with `writing-for-agents` for the writing style guide, and read [toolchain.md](../setup-repo/toolchain.md): it defines the target shape for `Taskfile.yml`, `.config/wt.toml`, and CI.

2. Read the primary sources for the session the user specifies. This may mean searching session logs on this machine (`~/.local/share/opencode/opencode.db`). If the user doesn't specify a session, default to the current one. Also read `gh pr checks` / `gh run list` for any PR the session pushed: a red check is evidence.

3. Look for candidates in every category below. A category is done when you have checked it against the evidence, even if it yields nothing.

4. Present the candidates in order of severity. Each one states the evidence (session, command, error line), the root cause, and the exact change.

5. Make the changes the user approves. Verify toolchain changes the same way `/setup-repo` does: `task --list`, `task ci`, and `wt hook pre-merge` in a fresh worktree. If hooks changed, ask the user to run `! wt config approvals add`.

## Categories

### Toolchain drift

The highest-yield category: an agent working around a missing task repeats the workaround every session.

- **Reinvented commands**: the agent ran raw toolchain commands (`go`, `wails`, `npm`, `docker`), read `--help` to build an invocation, or hit the same build error and workaround more than once. Each is a missing task. Add it, with the env vars, tags, and flags that made the workaround succeed.
- **Env vars and secrets**: a command failed until an env var, build tag, or secret was set by hand. Move it into the task. A task that can block (a locked secret store, an interactive prompt) fails fast with a message naming the fix.
- **New commands**: the session added a script, tool, generator, or service. It gets a task with a `desc`, and the `setup` or `ci` task calls it if a fresh checkout or CI needs it.
- **Cold worktrees**: a fresh worktree failed until something was installed or generated. That step belongs in `setup`, run by the `pre-start` hook.
- **Generated files**: keep generated source or embedded assets tracked when package consumers need them without running generation. Ignore disposable output and generate it in `setup`. Mixed directories are valid when tracked and ignored outputs serve different purposes; classify each output before changing tracking.

### CI parity

- **Red PR checks**: find the CI step that failed and the local step that should have caught it. Fix the gap so `task ci` (the `pre-merge` hook) catches it next time.
- **Unreachable platforms**: a CI job targets a platform the agent cannot run (e.g. Windows from Linux). If the dev host can reach that platform (WSL can run `.exe` through `powershell.exe`), add a task that runs those tests there. If it cannot, the task's `desc` says so, and `gh pr checks` becomes the gate. An agent that reports a platform as "unverified" and pushes anyway is this finding.
- **Drifted jobs**: CI steps that run raw commands instead of tasks. Move them into the Taskfile.
- **Stack fixes**: a fix for one PR in a stack landed on a different branch, leaving that PR red, or upward merges made the stack non-linear. The fix lands on the failing PR's branch, then upper branches are rebased sequentially in their own worktrees. Follow [CI fix recovery](../implement-spec/SKILL.md#ci-fix-recovery) for old-tip boundaries, checks, and approval before pushing rewritten history.

### Automated checks

Are there automated checks that could catch errors the agent made? Linting, typing, tests, filesystem linters? Read the repo's own check task and CI workflow first, so a check that exists but is unwired or silently broken is the finding, not a reinvention. A repo with no **guardrail** (no `pre-commit`/`pre-merge` hook and no CI job running its checks) is itself a finding. _Use when_ the agent made a mistake an automated check could have caught.

### Coding standards

Should the **reviewer agent** be given a new rule to enforce? Should an existing rule be removed or clarified? Classify the violation first: a **mechanical** one (a fixed syntactic pattern, a banned API, an import shape, a file-location rule) gets a deterministic check, full stop: a custom rule in the repo's own linter, wired into `task check`. Reserve `CODING_STANDARDS.md` for genuine **judgement calls** (cross-file consistency, "matches the surrounding style," anything no guardrail could ever substitute for). _Use when_ the reviewer agent failed to catch a mistake.

### Steering files

- **Navigation**: did the agent take long to find the right files? Are there hidden dependencies between files? Would a **navigation pointer** help?
- **AGENTS.md size**: should steering instructions move to coding standards or automated checks? _Use when_ `AGENTS.md` is large, in the repo or the user's global scope.
- **No-ops**: instructions in steering files that don't change the agent's behavior.

### Tool economy and information access

- **Tool economy**: expensive tool calls that could be streamlined: noisy output filtered with long `grep -v` chains (fix the noise at the source, in the task), token-heavy custom tooling.
- **Information access**: a crucial piece of information was unavailable to the agent. Teeing dev server logs, readonly access to third-party services.

## Reference

### Implementation vs Review

All work goes through two stages: implementation and review. The implementation agent has the most **context pressure**. It is responsible for exploration, writing code, and debugging failures.

The review agent has the least context pressure: it receives a diff, so it needs no exploration, and it often does not write code or debug.

This means the review agent should impose coding standards, not the implementation agent.

### Files

- `AGENTS.md`: pushed to the context window of every agent in this repo. Use it sparingly, mostly for **navigation pointers** to other files.
- `Taskfile.yml`: the single source of truth for commands. `task --list` is the command reference, so there is no separate commands doc.
- `.config/wt.toml`: worktree hooks. `pre-start` makes a worktree runnable, `pre-merge` is the local CI gate.
- `CODING_STANDARDS.md`: read during review, not implementation. Add **navigation pointers** to docs folders if it grows past 1,000 lines.
- Docs: reference files, pointed to by other files. Look for existing docs before writing new ones.
- Skills: for docs (their description goes into the agent's context window) or for user-invoked commands. Follow the `writing-for-agents` skill.
