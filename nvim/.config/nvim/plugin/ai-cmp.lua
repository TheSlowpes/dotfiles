local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({ gh("L3MON4D3/LuaSnip") })
require("luasnip").setup({})

-- Completion Engine
vim.pack.add({
	gh("hrsh7th/cmp-nvim-lsp"),
	gh("hrsh7th/cmp-buffer"),
	gh("hrsh7th/cmp-path"),
	gh("saadparwaiz1/cmp_luasnip"),
	gh("onsails/lspkind.nvim"),
	gh("hrsh7th/nvim-cmp"),
})

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- Initialize lspkind with custom symbols
		lspkind.init({
			symbol_map = {
				Copilot = "",
			},
		})

		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = {
				-- Select the next and previous item
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

				-- Scroll documentation
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Abort completion
				["<C-e>"] = cmp.mapping.abort(),

				-- Manually trigger completion
				["<C-Space>"] = cmp.mapping.complete(),

				-- Accept selection
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
			},
			sources = cmp.config.sources({
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = {
						menu = 50,
						abbr = 50,
					},
					ellipsis_char = "...",
					show_labelDetails = true,
					symbol_maps = {
						Copilot = "",
						Text = "󰉿",
						Method = "󰆧",
						Function = "󰊕",
						Constructor = "",
						Field = "󰜢",
						Variable = "󰀫",
						Class = "󰠱",
						Interface = "",
						Module = "",
						Property = "󰜢",
						Unit = "󰑭",
						Value = "󰎠",
						Enum = "",
						Keyword = "󰌋",
						Snippet = "",
						Color = "󰏘",
						File = "󰈙",
						Reference = "󰈇",
						Folder = "󰉋",
						EnumMember = "",
						Constant = "󰏿",
						Struct = "󰙅",
						Event = "",
						Operator = "󰆕",
						TypeParameter = "",
					},
				}),
			},
		})

		cmp.setup.filetype({ "sql", " mysql", "plsql" }, {
			sources = {
				{ name = "nvim_lsp" },
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
		})
	end,
})

local copilot_plugins = {
	gh("zbirenbaum/copilot.lua"),
	gh("AndreM222/copilot-lualine"),
	gh("zbirenbaum/copilot-cmp"),
	gh("sudo-tee/opencode.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("MeanderingProgrammer/render-markdown.nvim"),
	gh("hrsh7th/nvim-cmp"),
	gh("nvim-telescope/telescope.nvim"),
}

vim.pack.add(copilot_plugins)

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		local ok, copilot = pcall(require, "copilot")
		if ok then
			copilot.setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end

		pcall(function()
			require("copilot_cmp").setup()
		end)
	end,
})

pcall(function()
	require("opencode").setup({
		default_mode = "plan",
		ui = {
			display_context_size = true,
			display_cost = true,
		},
	})
end)

pcall(function()
	require("render-markdown").setup({
		anti_conceal = { enabled = false },
		file_types = { "markdown", "opencode_output" },
	})
end)

vim.filetype.add({
	extension = {
		opencode_output = "opencode_output",
	},
})
