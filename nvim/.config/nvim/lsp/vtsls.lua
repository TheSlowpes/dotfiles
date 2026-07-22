---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "typescript", "vue" },
  root_dir = function(bufnr, cb)
    local is_vue_project = function(root_dir)
      if not root_dir then
        return false
      end
      local package_json = root_dir .. "/package.json"
      if vim.fn.filereadable(package_json) == 1 then
        local lines = vim.fn.readfile(package_json)
        local content = table.concat(lines, "\n")
        return content:match("vue") ~= nil
      end
      return false
    end
    local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", ".git" })
    if root and is_vue_project(root) then
      cb(root)
    end
  end,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fs.normalize(vim.fn.stdpath("data") ..
          "/mason/packages/vue-language-server/node_modules/@vue/language-server"),
        languages = { "vue" },
        configNamespace = "typescript",
      }
    },
  },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vim.fs.normalize(vim.fn.stdpath("data") ..
              "/mason/packages/vue-language-server/node_modules/@vue/language-server"),
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
    typescript = {
      tsdk = vim.fs.normalize(vim.fn.stdpath("data") ..
        "/mason/packages/vue-language-server/node_modules/typescript/lib"),
    },
  },
}
