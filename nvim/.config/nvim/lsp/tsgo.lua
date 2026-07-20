---@type vim.lsp.Config
return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = { "javascript", "typescript" },
	root_markers = function(bufnr)
		local tshelper = require("tshelper")
		local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" })

		if root and not tshelper.is_vue_project(root) then
			return { "package.json" }
		end
		return nil
	end,
}
