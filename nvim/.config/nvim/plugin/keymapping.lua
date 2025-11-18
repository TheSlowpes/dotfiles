-- Keymapping
--  See `:help vim.keymap.set()`

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<CR>")

-- Toggle mouse support

vim.keymap.set("n", "<leader>m", function()
  vim.o.mouse = vim.o.mouse == "" and "a" or ""
  vim.notify("Mouse support: " .. (vim.o.mouse == "" and "disabled" or "enabled"))
end, { desc = "Toggle [M]ouse support" })

-- Diagnostic
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })


-- Exit terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Insert mode keymaps
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Navigation

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Moving or duplicating lines
vim.keymap.set("n", "<M-j>", ":m .+1<CR>", { desc = "Move line down" })
vim.keymap.set("v", "<M-j>", ":m .+1<CR>", { desc = "Move selected lines down" })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>", { desc = "Move line up" })
vim.keymap.set("v", "<M-k>", ":m .-2<CR>", { desc = "Move selected lines up" })
vim.keymap.set("n", "<M-S-j>", "yyp", { desc = "Duplicate line down" })

-- Remap for copying to system clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- Running lua code in the current buffer
vim.keymap.set("n", "<leader><C-x>", "<cmd>source %<CR>", { desc = "Run Lua code in current buffer" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run Lua code in current line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run Lua code in selected lines" })
