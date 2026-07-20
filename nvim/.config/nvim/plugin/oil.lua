local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("stevearc/oil.nvim"),
	gh("JezerM/oil-lsp-diagnostics.nvim"),
	gh("benomahony/oil-git.nvim"),
})

require("oil").setup({
	win_options = {
		signcolumn = "yes",
	},
	delete_to_trash = true,
	keymaps = {
		["<Esc><Esc>"] = { "actions.close", mode = "n" },
		["<S-j>"] = { "actions.select", opts = { horizontal = true } },
		["<S-l>"] = { "actions.select", opts = { vertical = true } },
		["<S-h>"] = { "actions.toggle_hidden" },
		["<BS>"] = { "actions.parent" },
	},
	float = {
		max_width = 0.4,
		override = function(defaults)
			defaults["col"] = 1
			return defaults
		end,
	},
})

vim.keymap.set("n", "-", function()
	require("oil").open_float()
end, { desc = "Open Oil in float" })

require("oil-lsp-diagnostics").setup({})
require("oil-git").setup({})
