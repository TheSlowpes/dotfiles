return {
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      { "kkharji/sqlite.lua", module = "sqlite" },
    },
    config = function()
      require("neoclip").setup({
        history = 200,
        enable_persistent_history = true,
        continuous_sync = true,
        initial_mode = "normal",
      })
      vim.keymap.set("n", "<M-p>", "<cmd>Telescope neoclip<cr>", { desc = "Clipboard history" })
    end,
  }
}
