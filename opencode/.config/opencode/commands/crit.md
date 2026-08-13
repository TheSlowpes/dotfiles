---
description: Review the current changes or a file with Crit
agent: build
---

Launch Crit for an inline browser review.

- If `$ARGUMENTS` is non-empty, run `crit $ARGUMENTS`.
- Otherwise run `crit` to review the current branch or working tree.
- Use the Bash tool's longest available timeout and wait for Crit to finish.
- Tell the user to leave comments in the browser and click Finish Review.
- Read Crit's output, address every unresolved comment, and reply with `crit comment --reply-to <id> --author 'OpenCode' '<response>'`.
- Do not resolve comments unless the user explicitly asks.
