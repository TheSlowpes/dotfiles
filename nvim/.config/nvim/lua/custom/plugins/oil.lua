return {
  {
    "stevearc/oil.nvim",
    opts = {
      win_options = {
        signcolumn = "yes",
      },
      keymaps = {
        ["<Esc><Esc>"] = { "actions.close", mode = "n" },
        ["<S-j>"] = { "actions.select", opts = { horizontal = true } },
        ["<S-l>"] = { "actions.select", opts = { vertical = true } },
        ["<S-h>"] = { "actions.toggle_hidden" }
      },
      float = {
        max_width = 0.4,
        override = function(defaults)
          defaults["col"] = 1
          return defaults
        end,
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    opts = {},
  },
  {
    "benomahony/oil-git.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    }
  },
  vim.keymap.set("n", "-", function()
    require("oil").open_float()
  end, { desc = "Open Oil in float" }),
}
