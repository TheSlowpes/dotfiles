# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues. Use the `gh` CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --json number,title,body,labels,comments,author,createdAt,updatedAt`. Filter this structured output with `jq` or `--jq` as needed.
- **List issues**: `gh issue list --state open --limit 1000 --search 'sort:created-asc' --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters. This retrieves the oldest issues first. If it returns 1000 items, treat the queue as incomplete: split the search into `created:` date ranges and fetch every range, narrowing any range that still returns 1000. Preserve the label/state filters, deduplicate issue numbers at range boundaries, and present the combined queue oldest first. If a single-day range still reaches the search cap, use a paginated API query instead and report any retrieval limit rather than presenting a partial queue as complete.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v`; `gh` does this automatically when run inside a clone.

## Complete discussions

Treat comments embedded in list results as a preview; `gh issue list` includes at most the first 100 comments per issue. Before evaluating reporter activity or resuming triage for a candidate, fetch its complete discussion:

```sh
gh api --paginate 'repos/{owner}/{repo}/issues/<number>/comments?per_page=100' --jq '.[] | {id, author: .user.login, body, createdAt: .created_at, updatedAt: .updated_at}'
```

Use all pages alongside the issue body and labels from **Read an issue**. This endpoint also retrieves PR conversation comments; for PR triage, additionally paginate `repos/{owner}/{repo}/pulls/<number>/comments` and `repos/{owner}/{repo}/pulls/<number>/reviews` for inline comments and reviews. Report any retrieval failure instead of treating missing comments as no reporter activity.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests; `/triage` reads this flag.)_

When set to `yes`, PRs run through the same labels and states as issues, using the `gh pr` equivalents:

- **Read a PR**: `gh pr view <number> --comments` and `gh pr diff <number>` for the diff.
- **List external PRs for triage**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments` then keep only `authorAssociation` of `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, or `NONE` (drop `OWNER`/`MEMBER`/`COLLABORATOR`).
- **Comment / label / close**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

GitHub shares one number space across issues and PRs, so a bare `#42` may be either: resolve with `gh pr view 42` and fall back to `gh issue view 42`.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant issue"

Use the structured **Read an issue** command above so the body, labels, and comments are all available.
