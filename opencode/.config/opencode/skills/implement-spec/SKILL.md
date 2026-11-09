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

Worktrunk (`wt`) owns every worktree. Its project hooks in `.config/wt.toml` make a fresh worktree runnable (`pre-start`) and gate every merge on the repo's checks (`pre-merge`), so a branch that reaches the integration branch has already passed them. Required setup finishes before implementer dispatch; `post-start` is only for optional background work. See `wt <command> --help`.

- Agent shells have no `wt` shell integration: always pass `--no-cd`, and address worktrees with `wt -C <path>` or the shell's working directory.
- Run every build, test, and check through `task` (`task --list`). Raw toolchain commands skip the env vars, tags, and generated assets the tasks carry.
- An unapproved hook is skipped, which silently skips the checks. Hooks must be approved before any worktree is created.

## Steps

1. Read the spec and issues to understand the task graph.

2. Before creating worktrees or dispatching implementation, run `gh stack --help` and `gh auth status`. Confirm `gh stack` is available and authenticated for the target GitHub host, and that stacked PRs are available for the target repository. If unavailable or access cannot be confirmed, stop and ask the user to make `gh stack` available for this repository before retrying; there is no regular-PR fallback. Confirm the repo is wired: `Taskfile.yml` and `.config/wt.toml` exist, and `wt hook show` lists a `pre-merge` hook. If any is missing, stop and tell the user to run `/setup-repo`. Then ask the user to run `! wt config approvals add` once, so hooks run without prompts.

3. (optional) Use an **exploration subagent** to conduct any exploration required by the issues; relevant codebase files or external documentation. Ensure the exploration subagent can save files, it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

4. Create the first **integration branch** in its own worktree with `wt switch --create <branch> --no-cd`, then run `gh stack init <branch>` inside that worktree to start the stack. The **integration worktree** is the only place `gh stack` runs.

5. Use **implementer subagents** to implement each issue. Create each one's worktree before dispatching it, with `wt switch --create <issue-branch> --base <integration-branch> --no-cd`, and hand the subagent the worktree path. Each implementer subagent:
    - implements the issue according to the documented repo conventions, inside its worktree only;
    - commits its work following the repo's commit conventions;
    - reports done only once `wt hook pre-merge` passes in its worktree.

6. Once an **implementer subagent** completes, merge its branch from the integration worktree: `wt merge <integration-branch> --branch <issue-branch> --no-squash`. This rebases, runs the `pre-merge` hooks, fast-forwards the integration branch, and removes the issue worktree. Run merges one at a time. If the rebase conflicts or a hook fails, the issue worktree is left in place: send the failure back to its implementer subagent and retry the merge once it reports done.

7. If this changes the **frontier** of available issues, use the coderabbit cli (see `coderabbit --help`) to review the current state of the code and use **implementer subagents** to address any issues on the current integration branch. Once coderabbit returns no findings, add a new branch to the stack only if there are undispatched issues ready to implement (`gh stack add <branch>` in the integration worktree). Set `<integration-branch>` to this new top branch before dispatching more implementers or merging any completed work, including work already in flight. The integration worktree now holds the new top branch. An empty frontier adds no branch; wait for in-flight work, or proceed to step 8 when all issues are complete.

8. Once all issues are complete, call the Skill tool with `code-review` on the top branch against `main`. Fix all issues raised by the code review in a single **implementer subagent**, merged back as in step 6.

9. Fetch the stack's trunk from its remote and verify its latest tip is an ancestor of the bottom stack branch with `git merge-base --is-ancestor <fetched-trunk-tip> <bottom-branch>`. If not, follow **CI fix recovery** below to restack onto the latest trunk and rerun checks before submission. Run the repo's CI task (the one `.github/workflows` calls) in the integration worktree. It must pass before anything is pushed.

10. Use `gh stack submit --auto --open` to create PRs non-interactively, ready for review rather than as drafts, then `gh pr checks --watch` on each PR. Before reporting completion, fetch the trunk again and verify its latest tip is an ancestor of the bottom stack branch, and each stack branch is an ancestor of the next. The work is done when every check on every PR is green and this full chain includes the latest fetched trunk; "unverified on platform X" is not done. For red checks or an advanced trunk not yet incorporated, follow **CI fix recovery** below and rerun checks on the updated PR heads. Note the gap between local checks and CI for `/maintain-repo`.

11. Clean up: `wt list` should show no issue worktrees left. Remove the integration worktree with `wt remove <integration-branch> --no-delete-branch`.

## CI fix recovery

Use this sequence for CI fixes or a trunk that has advanced beyond the stack. Restack sequentially in each branch's own worktree. Keep the stack linear instead of merging a changed lower branch into an upper branch.

1. Before fixing anything, fetch the trunk, pause implementers, and require clean worktrees for the affected branches: the failing branch and those above it, or the entire stack if the latest trunk is not an ancestor of its bottom branch. Use `wt` to create any missing worktrees. Record the stack order, each branch's old local tip, and its published remote tip, if any. Verify adjacent stack branches form an ancestor chain and local tips match published tips where they exist. If stack-layer history has already diverged or contains merge commits, stop and ask how to repair it rather than replaying an ambiguous range. For a stale trunk, also record the merge-base of the bottom branch and the fetched trunk as `<old-trunk-base>`.
2. If recovering from a red check, dispatch an **implementer subagent** to fix and commit on the failing PR's branch in its own worktree. For a trunk-only refresh, skip this step. Preserve the old tips recorded before any changes.
3. If the trunk needs incorporating, first run `git rebase --onto <fetched-trunk-tip> <old-trunk-base>` in the bottom branch's worktree. Then, for each affected upper branch, bottom to top, run `git rebase --onto <updated-parent-tip> <old-parent-tip>` in that branch's worktree. Use its immediate parent's recorded old tip as the boundary, even after that parent has been rebased. This replays only each branch's own commits. Resolve conflicts there and run `git rebase --continue`; if the resolution requires a decision, pause and ask. Finish each rebase before starting the next.
4. Run each changed branch's CI task in its worktree and verify the ancestor chain from the fetched trunk through every stack branch. Ask for approval before pushing rewritten published history, naming the affected branches. After approval, push bottom to top to each PR's remote branch, or proceed to step 10 for initial submission of an unpublished stack. For rewritten published branches, use `--force-with-lease=refs/heads/<remote-branch>:<recorded-remote-tip>`; a rejected lease means stop and inspect the remote changes, not overwrite them.
5. Confirm each PR's head matches its pushed commit before running `gh pr checks --watch` again. Wait for checks on the new commits rather than accepting old results. Fetch the trunk again before reporting completion; if its latest tip is not an ancestor of the bottom branch, repeat this recovery with newly recorded tips. Recovery is complete only when the full chain from the latest fetched trunk passes every required check.
