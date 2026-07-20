vim.pack.add({ "https://github.com/mbbill/undotree" })
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 35
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_HelpLine = 1
vim.g.undotree_DiffCommand = "diff"
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "[U]ndotree" })
