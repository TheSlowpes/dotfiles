local function gh(repo)
	return "https://github.com/" .. repo
end

local bookmark_plugins = {
	gh("heilgar/bookmarks.nvim"),
	gh("kkharji/sqlite.lua"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-lua/plenary.nvim"),
}

vim.pack.add(bookmark_plugins)
require("bookmarks").setup({
	default_mappings = false,
})
require("telescope").load_extension("bookmarks")

local bookmark_commands = require("bookmarks.commands")
local bookmark_autocmds = require("bookmarks.autocmds")
local bookmark_navigation = require("bookmarks.navigation")

vim.keymap.set("n", "<leader>ba", function()
	local bufnr = bookmark_commands.add_bookmark()
	bookmark_autocmds.refresh_buffer(bufnr)
end, { desc = "[B]ookmark [A]dd" })

vim.keymap.set("n", "<leader>bd", function()
	local bufnr = bookmark_commands.remove_bookmark()
	bookmark_autocmds.refresh_buffer(bufnr)
end, { desc = "[B]ookmark [D]elete" })

vim.keymap.set("n", "<leader>bn", function()
	local bookmarks = bookmark_autocmds.get_buffer_bookmarks(vim.api.nvim_get_current_buf())
	bookmark_navigation.jump_to_next(bookmarks)
end, { desc = "[B]ookmark [N]ext" })

vim.keymap.set("n", "<leader>bp", function()
	local bookmarks = bookmark_autocmds.get_buffer_bookmarks(vim.api.nvim_get_current_buf())
	bookmark_navigation.jump_to_prev(bookmarks)
end, { desc = "[B]ookmark [P]revious" })

vim.keymap.set("n", "<leader>sb", require("telescope").extensions.bookmarks.list, { desc = "[S]earch [B]ookmarks" })
