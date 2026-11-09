# Issue tracker: Linear

Issues and specs for this repo live as Linear issues. Use the `linear` MCP tools for all operations.

## Conventions

- **Create an issue**: call `linear_save_issue` with `title`, `description`, the repo's Linear `team`, and its `project` when one is configured.
- **Read an issue**: call `linear_get_issue` with the issue identifier and `includeRelations: true`, then call `linear_list_comments` with `issueId`.
- **List issues**: call `linear_list_issues` with the appropriate `team`, `project`, `state`, `label`, or `assignee` filters and request the fields needed by the skill.
- **Comment on an issue**: call `linear_save_comment` with `issueId` and `body`.
- **Apply / remove labels**: first read the issue's current labels with `linear_get_issue`, then call `linear_save_issue` with the complete updated `labels` array. The `labels` argument replaces the full label set. Use `linear_list_issue_labels` to resolve labels and `linear_create_issue_label` only when a required label does not exist.
- **Close**: use `linear_list_issue_statuses` for the issue's team to resolve the appropriate completed or canceled status, then call `linear_save_issue` with the issue identifier and that `state`. Add a closing comment with `linear_save_comment` when the skill supplies one.

Resolve the workspace with `linear_get_workspace` and teams or projects with `linear_list_teams` and `linear_list_projects`; unlike `gh`, Linear does not infer issue scope from the Git remote.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests; `/triage` reads this flag.)_

When set to `yes`, use Linear's diff tools for pull-request operations:

- **Read a PR**: call `linear_get_diff` with the Linear review URL, GitHub PR URL, diff slug, or pull request ID, then call `linear_get_diff_threads` for its discussion.
- **List PRs for triage**: call `linear_list_diffs` with `status` and repository filters. The Linear MCP does not expose GitHub's `authorAssociation`; only treat a PR as external when its author can be established as outside the repository team.
- **Comment / review / merge**: use `linear_save_diff_comment`, `linear_submit_diff_review`, and `linear_merge_diff`. Diff labels and closing are not exposed by these tools; track triage labels and state on the associated Linear issue.

Linear issue identifiers such as `TEAM-42` are distinct from diff identifiers. Use `linear_get_issue` for issue identifiers and `linear_get_diff` for Linear review URLs, GitHub PR URLs, diff slugs, or pull request IDs.

## When a skill says "publish to the issue tracker"

Create a Linear issue with `linear_save_issue`.

## When a skill says "fetch the relevant issue"

Call `linear_get_issue` with the issue identifier, then `linear_list_comments` with `issueId`.
