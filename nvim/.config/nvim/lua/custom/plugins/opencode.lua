return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
      init = function()
        vim.g.copilot_nes_debounce = 500
        vim.lsp.enable("copilot_ls")
      end,
    },
    cmd = "Copilot",
    event = "BufEnter",
    config = function()
      local ok, copilot = pcall(require, "copilot")
      if not ok then
        return
      end
      copilot.setup({
        suggestion = { enabled = false, },
        panel = { enabled = false, },
        nes = {
          enabled = true,
          keymap = {
            accept_and_goto = "<S-Tab>",
            accept = "false",
            dismiss = "<Esc>",
          },
        },
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
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode-output" },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
      },
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    }
  },
}
