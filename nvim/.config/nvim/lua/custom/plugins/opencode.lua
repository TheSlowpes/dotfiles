return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local ok, copilot = pcall(require, "copilot")
      if not ok then
        return
      end
      copilot.setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "AndreM222/copilot-lualine",
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "sudo-tee/opencode.nvim",
    config = function()
      require("opencode").setup({
        default_mode = 'plan',
        ui = {
          display_context_size = true,
          display_cost = true,
        }
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
      },
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    }
  },
}
