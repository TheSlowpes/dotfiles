local function gh(repo)
	return "https://github.com/" .. repo
end
vim.pack.add({
	{ src = gh("AckslD/nvim-neoclip.lua") },
	{ src = gh("nvim-telescope/telescope.nvim") },
	{ src = gh("kkharji/sqlite.lua") },
})

require("neoclip").setup({
	history = 200,
	enable_persistent_history = true,
	continuous_sync = true,
	initial_mode = "normal",
})

vim.keymap.set("n", "<M-p>", "<cmd>Telescope neoclip<cr>", { desc = "Clipboard history" })
