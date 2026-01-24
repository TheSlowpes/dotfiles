---@type vim.lsp.Config
return {
  cmd = { "sqls" },
  filetypes = { "sql", "mysql", "plsql" },
  root_markers = { ".sqls.yml", ".sqls.yaml", ".git" },
  settings = {
    sqls = {
      connections = {
        -- You can configure database connections here
        -- Example:
        -- {
        --   driver = "postgresql",
        --   dataSourceName = "host=localhost user=postgres dbname=example sslmode=disable",
        -- },
      },
    },
  },
}