local function gh(repo)
	return "https://github.com/" .. repo
end

-- Useful status updates for LSP.
vim.pack.add({ gh("j-hui/fidget.nvim") })
require("fidget").setup({})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

vim.pack.add({
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("mason-org/mason-lspconfig.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
})

-- Automatically install LSPs and related tools to stdpath for Neovim
require("mason").setup({})

local servers = {
	"lua_ls",
	"pyright",
	"gopls",
	"sqls",
	"vue_ls",
	"vtsls",
	"tsc",
}

local ensure_installed = vim.list_extend({}, servers)
local formatters = {}
for _, ft_formatters in pairs(require("config.formatters")) do
	for _, formatter in ipairs(ft_formatters) do
		-- gofmt ships with Go rather than a Mason package.
		if formatter ~= "gofmt" then
			formatters[formatter] = true
		end
	end
end
vim.list_extend(ensure_installed, vim.fn.sort(vim.tbl_keys(formatters)))
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Preserve upstream TypeScript 7 binary discovery, but leave Vue to vtsls.
local tsc_root_dir = vim.lsp.config.tsc.root_dir or {}
vim.lsp.config("tsc", {
	filetypes = { "javascript", "typescript" },
	root_dir = function(bufnr, on_dir)
		if not require("config.vue").is_vue_project(bufnr) then
			tsc_root_dir(bufnr, on_dir)
		end
	end,
})

for _, server in ipairs(servers) do
	local config_path = vim.fn.stdpath("config") .. "/lsp/" .. server .. ".lua"
	if vim.fn.filereadable(config_path) == 1 then
		vim.lsp.config(server, dofile(config_path))
	end
	vim.lsp.enable(server)
end
