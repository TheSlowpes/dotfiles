local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({ gh("nvim-lualine/lualine.nvim") })

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "horizon",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filtetypes = {
			statusline = { "mason" },
			winbar = { "mason" },
		},
		ignore_focus = {},
		always_divide_middle = true,
		glocal_status = true,
		refresh = {
			statusline = 1000,
			winbar = 1000,
			refresh_time = 16,
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"FileType",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename", "filesize" },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	winbar = {
		lualine_x = { "lsp_status" },
		lualine_z = { "copilot" },
	},
})
