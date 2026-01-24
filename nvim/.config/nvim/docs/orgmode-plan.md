# Orgmode Implementation Plan

## Summary

Add `nvim-orgmode/orgmode` with full ecosystem support including org-bullets, org-roam, and telescope integration. The configuration uses `<leader>O` as the keymap prefix and reads the org directory from environment variable `NVIM_ORG_DIR` (defaulting to `~/org/`).

## Files Created/Modified

### Created: `nvim/lua/custom/plugins/orgmode.lua`

Plugin file containing:

- **nvim-orgmode/orgmode** - Core org-mode functionality
- **nvim-orgmode/org-bullets.nvim** - Pretty bullet rendering
- **chipsenkbeil/org-roam.nvim** - Zettelkasten-style linking
- Telescope integration for searching org files

### Modified: `nvim/init.lua`

Added `<leader>O` group to which-key spec.

## Configuration Details

### Environment Variable

```lua
local org_dir = vim.fn.expand(vim.env.NVIM_ORG_DIR or "~/org")
```

Set `NVIM_ORG_DIR` in your shell config (e.g., `.zshrc`, `.bashrc`) to customize:

```bash
export NVIM_ORG_DIR="$HOME/Documents/org"
```

### Directory Structure

Create this structure manually or let orgmode create files as needed:

```
~/org/                     # Or $NVIM_ORG_DIR
├── inbox.org              # Quick captures, to be refiled
├── todo.org               # Main task list
├── projects/              # Project-specific files
│   └── *.org
├── notes/                 # General notes
│   └── *.org
├── journal/               # Daily journal entries
│   └── YYYY-MM-DD.org
├── roam/                  # Org-roam notes (Zettelkasten)
│   └── *.org
└── archive.org            # Completed/archived items
```

### TODO Keywords

```
TODO | IN-PROGRESS | WAITING → DONE | CANCELLED
```

Cycle through states with `<S-CR>` in org files.

### Capture Templates

| Key | Type | Description |
|-----|------|-------------|
| `t` | Task | Basic TODO item with timestamp |
| `n` | Note | Quick note with timestamp |
| `j` | Journal | Daily journal entry |
| `m` | Meeting | Meeting notes with attendees section |
| `c` | Code | Code snippet/reference |
| `i` | Idea | Ideas for later exploration |

## Keybindings

### Global Keybindings (`<leader>O` prefix)

| Keybinding | Action |
|------------|--------|
| `<leader>Oa` | Open agenda view |
| `<leader>Oc` | Capture new item |
| `<leader>Ot` | Open todo.org |
| `<leader>Oi` | Open inbox.org |
| `<leader>Os` | Schedule item |
| `<leader>Od` | Set deadline |
| `<leader>Or` | Refile item |
| `<leader>OA` | Archive subtree |
| `<leader>O/` | Search org files (telescope) |
| `<leader>On` | Org-roam: Find/create node |
| `<leader>Ol` | Org-roam: Insert link |
| `<leader>Ob` | Org-roam: Show backlinks |

### Org-file Keybindings (buffer-local, automatic)

| Keybinding | Action |
|------------|--------|
| `<S-CR>` | Cycle TODO state |
| `<TAB>` | Fold/unfold heading |
| `<S-TAB>` | Global fold cycle |
| `<CR>` | Follow link |
| `<C-CR>` | Insert heading below |

## Proposed Workflow

### Daily Routine

1. **Quick Capture** (`<leader>Oc`)
   - Capture thoughts, tasks, or notes without context switching
   - Items go to `inbox.org` for later processing

2. **Morning Review** (`<leader>Oa`)
   - View today's scheduled tasks and deadlines
   - Review agenda week view
   - Refile items from inbox to appropriate locations (`<leader>Or`)

3. **During Work**
   - Toggle TODO states with `<S-CR>`
   - Add notes to tasks with timestamps
   - Schedule tasks with `<leader>Os`
   - Set deadlines with `<leader>Od`

4. **End of Day**
   - Archive completed items (`<leader>OA`)
   - Review tomorrow's schedule in agenda

### Building a Knowledge Base (Org-Roam)

Org-roam implements the Zettelkasten method for building a personal knowledge base:

1. **Create atomic notes** (`<leader>On`)
   - One concept per note
   - Give it a descriptive title

2. **Link related notes** (`<leader>Ol`)
   - Build connections between concepts
   - Links are bidirectional

3. **Discover patterns** (`<leader>Ob`)
   - Review backlinks to find unexpected connections
   - Your knowledge graph grows organically

### Example Org File

```org
* TODO Review quarterly goals                                    :work:planning:
  SCHEDULED: <2026-01-22 Thu>
  :PROPERTIES:
  :CREATED: [2026-01-21 Wed 10:30]
  :END:

  - [ ] Revenue targets
  - [ ] Team hiring plan
  - [ ] Product roadmap

* IN-PROGRESS Write documentation for new API                    :work:docs:
  DEADLINE: <2026-01-25 Sun>

** Notes
   - Endpoint: /api/v2/users
   - Need to document rate limiting

* DONE Set up Neovim orgmode                                     :personal:tools:
  CLOSED: [2026-01-21 Wed 14:00]
```

## Tips for Getting Started

1. **Start small**: Just use `<leader>Oc` to capture and `<leader>Oa` to review
2. **Don't over-organize**: Let structure emerge from your actual needs
3. **Use tags**: Add tags like `:work:` or `:personal:` to filter agenda views
4. **Regular review**: Spend 5-10 minutes daily processing your inbox
5. **Archive often**: Keep active files clean by archiving completed items
