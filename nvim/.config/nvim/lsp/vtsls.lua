---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "typescript", "vue" },
  root_dir = require("config.vue").root_dir,
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
