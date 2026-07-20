---@type vim.lsp.Config
return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = function(bufnr)
		local ts_helper = require("tshelper")
		local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" })

		if root and ts_helper.is_vue_project(root) then
			return { "package.json" }
		end
		return nil
	end,
}
