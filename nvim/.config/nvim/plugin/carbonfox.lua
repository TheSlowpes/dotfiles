local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({ gh("EdenEast/nightfox.nvim") })

vim.cmd.colorscheme("carbonfox")
