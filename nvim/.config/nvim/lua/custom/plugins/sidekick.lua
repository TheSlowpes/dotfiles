return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- If there is a next edit, jump to it otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<tab>" -- fall back to normal tab behavior
        end
      end,
      expr = true,
      desc = "Goto/Apply next edit suggestion",
    },
    {
      "<leader>to",
      function()
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "[T]oggle Sidekick [O]pencode CLI",
    },
    {
      "<leader>op",
      function()
        require("sidekick.cli").prompt()
      end,
      desc = "[O]pen Sidekick [P]rompt",
    },
  }
}
