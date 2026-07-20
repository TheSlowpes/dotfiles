local function gh(repo) return 'https://github.com/' .. repo end

-- [[Formatting]]
vim.pack.add { 
  gh 'stevearc/conform.nvim',
  gh 'mason-org/mason.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}
local formatters_by_ft = {
  lua = {"stylua"},
  python = {"black"},
  javascript = {"prettier"},
  typescript = {"prettier"},
  go = {"gofmt", "goimports"},
}
require('mason').setup()
local mason_tool_installer = require("mason-tool-installer")
local formatters = {}

for _, ft_formatters in pairs(formatters_by_ft) do
  for _, formatter in ipairs(ft_formatters) do
    formatters[formatter] = true
  end
end

mason_tool_installer.setup({ ensure_installed = vim.tbl_keys(formatters)})

require('conform').setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local enabled_filetypes = {
      lua = true,
      python = true,
      javascript = true,
      typescript = true,
      go = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = formatters_by_ft,
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format {async = true } end, { desc = '[F]ormat buffer' })
