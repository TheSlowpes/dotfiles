---
name: dev-environment
description: Use when working on Go, Wails, Vue, TypeScript, pnpm, or Taskfile projects configured by these dotfiles. Covers the expected runtimes, package manager, task runner, and local development commands.
---

# Development Environment

- Use `pnpm`, not npm or yarn, for JavaScript and TypeScript dependencies.
- Prefer commands declared in `Taskfile.yml` over duplicating long shell commands.
- Run `wails doctor` when diagnosing Wails toolchain or platform dependency failures.
- Treat Go modules and frontend package dependencies as project-local state.
- Do not update pinned runtime or tool versions unless the user explicitly requests it.
- Use `lazygit` interactively only when requested; use ordinary Git commands for automation.
- Use `hunk` when the user requests an interactive terminal diff review.
- Use `crit` when the user requests an inline browser review.
