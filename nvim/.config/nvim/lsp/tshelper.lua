return {
	is_vue_project = function(root_dir)
		if not root_dir then
			return false
		end
		local package_json = root_dir .. "/package_json"
		if vim.fn.filereadable(package_json) == 1 then
			local lines = vim.fn.readfile(package_json)
			local content = table.concat(lines, "\n")
			return content:match('"vue"') ~= nil
		end
		return false
	end,
}
