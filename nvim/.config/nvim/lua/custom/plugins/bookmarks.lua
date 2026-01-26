return {
  {
    "heilgar/bookmarks.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("bookmarks").setup({
        default_mappings = false,
      })
      require("telescope").load_extension("bookmarks")

      vim.keymap.set("n", "<leader>ba", require("bookmarks.commands").add_bookmark, { desc = "[B]ookmark [A]dd" })
      vim.keymap.set("n", "<leader>bd", require("bookmarks.commands").remove_bookmark, { desc = "[B]ookmark [D]elete" })
      vim.keymap.set("n", "<leader>bn", require("bookmarks.navigation").jump_to_next, { desc = "[B]ookmark [N]ext" })
      vim.keymap.set("n", "<leader>bp", require("bookmarks.navigation").jump_to_prev, { desc = "[B]ookmark [P]revious" })
      vim.keymap.set("n", "<leader>sb", require("telescope").extensions.bookmarks.list, { desc = "[S]earch [B]ookmarks" })
    end,
  },
}
