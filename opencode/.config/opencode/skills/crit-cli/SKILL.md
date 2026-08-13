---
name: crit-cli
description: Use when reading, creating, replying to, sharing, or synchronizing Crit review comments. Covers crit comment, comments, share, pull, and push; not the interactive /crit review command.
compatibility: opencode
---

# Crit CLI

Use `crit status` to locate an active review and `crit comments --json` to read unresolved comments.

## Comments

Always identify agent-authored comments:

```sh
crit comment --author 'OpenCode' 'Review-level comment'
crit comment --author 'OpenCode' path/to/file.go 'File-level comment'
crit comment --author 'OpenCode' path/to/file.go:42 'Line comment'
crit comment --reply-to <id> --author 'OpenCode' 'Reply'
```

Only pass `--resolve` when the user explicitly requests it. Use `crit comment --json` for three or more comments.

## GitHub

```sh
crit pull [pr-number]
crit push --dry-run [pr-number]
crit push --event comment [pr-number]
```

## Sharing

```sh
crit share <file>
crit unpublish <file>
```

Always relay the generated URL. Sharing uploads review material, so do it only at the user's request.
