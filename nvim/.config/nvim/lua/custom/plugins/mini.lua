return {
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
      require("mini.comment").setup({
        mappings = {
          comment = "<M-/>",
          comment_line = "<M-/>",
          comment_visual = "<M-/>",
          textobject = "gc",
        },
      })
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.splitjoin").setup({
        mappings = {
          toggle = "<M-s>",
        },
      })
      require("mini.diff").setup()
      require("mini.notify").setup()
    end,
  },
  vim.keymap.set("n", "<leader>ht", function()
    require("mini.diff").toggle_overlay(0)
  end, { desc = "[H]unk [T]oggle" }),
}
