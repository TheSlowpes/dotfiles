vim.pack.add({
	{ src = "https://github.com/folke/persistence.nvim" },
})

local persistence = require("persistence")

persistence.setup({
	dir = vim.fn.stdpath("state") .. "/sessions/",
	need = 1,
	branch = true,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
	callback = function()
		if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
			local session_file = persistence.current()
			if session_file and vim.fn.filereadable(session_file) == 1 then
				vim.defer_fn(function()
					persistence.load()
				end, 0)
			end
		end
	end,
	nested = true,
})

vim.api.nvim_create_autocmd("StdinReadPre", {
	callback = function()
		vim.g.started_with_stdin = true
	end,
})

vim.keymap.set("n", "<leader>Qs", function()
	persistence.load()
end, { desc = "Restore Session (current dir)" })

vim.keymap.set("n", "<leader>QS", function()
	persistence.select()
end, { desc = "Select Session" })

vim.keymap.set("n", "<leader>Ql", function()
	persistence.load({ last = true })
end, { desc = "Restore Last Session" })

vim.keymap.set("n", "<leader>Qd", function()
	persistence.stop()
end, { desc = "Don't Save Current Session" })
