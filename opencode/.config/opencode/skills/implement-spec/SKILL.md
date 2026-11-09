---
name: implement-spec
description: "Implement the result of /to-spec and /to-issues in code."
disable-model-invocation: true
---

You have been provided a spec. This spec should have issues associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-repo`.

The goal is the entire spec implemented on a single **integration stack**, with every branch being stacked on the previous piece of implementation. See `gh stack --help`.

The issues are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of issues which are ready to be grabbed.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, issues, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

## Worktrees

Worktrunk (`wt`) owns every worktree. Its project hooks in `.config/wt.toml` make a fresh worktree runnable (`post-start`) and gate every merge on the repo's checks (`pre-merge`), so a branch that reaches the integration branch has already passed them. See `wt <command> --help`.

- Agent shells have no `wt` shell integration: always pass `--no-cd`, and address worktrees with `wt -C <path>` or the shell's working directory.
- Run every build, test, and check through `task` (`task --list`). Raw toolchain commands skip the env vars, tags, and generated assets the tasks carry.
- An unapproved hook is skipped, which silently skips the checks. Hooks must be approved before any worktree is created.

## Steps

1. Read the spec and issues to understand the task graph.

2. Confirm the repo is wired: `Taskfile.yml` and `.config/wt.toml` exist, and `wt hook show` lists a `pre-merge` hook. If any is missing, stop and tell the user to run `/setup-repo`. Then ask the user to run `! wt config approvals add` once, so hooks run without prompts.

3. (optional) Use an **exploration subagent** to conduct any exploration required by the issues; relevant codebase files or external documentation. Ensure the exploration subagent can save files, it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

4. Create the first **integration branch** in its own worktree with `wt switch --create <branch> --no-cd`, then run `gh stack init <branch>` inside that worktree to start the stack. The **integration worktree** is the only place `gh stack` runs.

5. Use **implementer subagents** to implement each issue. Create each one's worktree before dispatching it, with `wt switch --create <issue-branch> --base <integration-branch> --no-cd`, and hand the subagent the worktree path. Each implementer subagent:
    - implements the issue according to the documented repo conventions, inside its worktree only;
    - commits its work following the repo's commit conventions;
    - reports done only once `wt hook pre-merge` passes in its worktree.

6. Once an **implementer subagent** completes, merge its branch from the integration worktree: `wt merge <integration-branch> --branch <issue-branch> --no-squash`. This rebases, runs the `pre-merge` hooks, fast-forwards the integration branch, and removes the issue worktree. Run merges one at a time. If the rebase conflicts or a hook fails, the issue worktree is left in place: send the failure back to its implementer subagent and retry the merge once it reports done.

7. If this changes the **frontier** of available issues, use the coderabbit cli (see `coderabbit --help`) to review the current state of the code and use **implementer subagents** to address any issues. Once coderabbit returns no findings, add a new branch to the stack (`gh stack add <branch>` in the integration worktree) and kick off more **implementer subagents** based on it. This allows for maximum concurrency.

8. Once all issues are complete, call the Skill tool with `code-review` on the top branch against `main`. Fix all issues raised by the code review in a single **implementer subagent**, merged back as in step 6.

9. Run the repo's CI task (the one `.github/workflows` calls) in the integration worktree. It must pass before anything is pushed.

10. Use `gh stack submit` to create PRs for the stack, then `gh pr checks --watch` on each PR. The work is done when every check on every PR is green; "unverified on platform X" is not done. Fix a red check with an **implementer subagent** on the failing PR's own branch, then merge that branch into each branch above it, bottom to top, each in its own worktree (`git merge`, not `gh stack rebase`: rebasing branches checked out in several worktrees, or containing merges, fails or replays resolved conflicts). Note the gap between local checks and CI for `/maintain-repo`.

11. Clean up: `wt list` should show no issue worktrees left. Remove the integration worktree with `wt remove <integration-branch> --no-delete-branch`.
