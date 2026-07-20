local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("akinsho/toggleterm.nvim"),
})

require("toggleterm").setup({
	size = 15,
	direction = "horizontal",
	hide_numbers = true,
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	close_on_exit = false,
	persist_size = true,
	persist_mode = true,
	persist_sessions = true,
	scrollback = 5000,
})

vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "[T]oggle [T]erminal" })
