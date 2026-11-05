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

## Steps

1. Read the spec and issues to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the issues; relevant codebase files or external documentation. Ensure the exploration subagent can save files, it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the first **integration branch** and initiate a new stack with `gh stack init`.

4. Use **implementer subagents** to implement each issue, each in its own worktree on its own branch. Each implementer subagent:
    - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
    - implements the issue according to the documented repo conventions;
    - merges the integration branch tip into its own branch before reporting done

5. Once an **implementer subagent** completes, merge its work to the integration branch with a **merger subagent**.

6. If this changes the **frontier** of available issues, use the coderabbit cli (see `coderabbit --help`) to review the current state of the code and use **implementer subagents** to address any issues. Once coderabbit returns no findings, add a new branch to the stack (`gh stack add`) and kick off more **implementer subagents** to work on the newly unblocked issues. This allows for maximum concurrency.

7. Once all issuer are complete, call the Skill tool with `code-review` on the top branch against `main`. Fix all issues raised by the code review in a single **implementer subagent**.

8. Use `gh stack submit` to create PRs for the stack.

9. Clean up all **implementer subagent** worktrees.
