---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	filetypes = { "javascript", "typescript", "vue" },
	root_markers = function(bufnr)
		local ts_helper = require("tshelper")
		local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" })

		if root and ts_helper.is_vue_project(root) then
			return { "package.json" }
		end
		return nil
	end,
	init_options = {
		plugins = {
			name = "@vue/typescript-plugin",
			location = vim.fs.normalize(
				vim.fn.stdpath("data") .. "mason/packages/vue-language-server/node_modules/@vue/language-server"
			),
			languages = { "vue" },
			configNamespace = "typescript",
		},
	},
}
