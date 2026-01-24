# AGENTS.md - Neovim Configuration

## Build/Lint/Test
- No build system; this is a Neovim config managed by lazy.nvim
- Lua formatting: `stylua` (run via conform.nvim on save)
- Validate config: Open Neovim and check for errors with `:messages`

## Code Style

### Imports & Module Pattern
- Plugin specs: Return table directly `return { { "plugin/name", config = function() ... end } }`
- Utility modules: `local M = {} ... return M` with top-level requires

### Formatting
- Indentation: 2 spaces for Lua, 4 spaces default
- Quotes: Double quotes for strings
- Trailing commas in tables

### Naming
- Variables/functions: `snake_case`
- Module tables: `local M = {}`
- Keymap descriptions: Bracketed hints like `"[S]earch [H]elp"`

### Error Handling
- Use `pcall` for optional features: `pcall(require("telescope").load_extension, "fzf")`
- Conditional checks: `if client and client:supports_method(...) then`

### Comments
- Section headers: `-- [[ Section Name ]]`
- Notes: `-- NOTE:` or `-- See `:help ...``
