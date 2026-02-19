return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    need = 1,
    branch = true,
  },
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("persistence_auto_restore", { clear = true }),
      callback = function()
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          local session_file = persistence.current()

          if session_file and vim.fn.filereadable(session_file) == 1 then
            vim.defer_fn(function()
              persistence.load()
            end, 0)
          end
        end
      end,
      nested = true,
    })

    vim.api.nvim_create_autocmd("StdinReadPre", {
      callback = function()
        vim.g.started_with_stdin = true
      end,
    })
  end,
  keys = {
    {
      "<leader>Qs",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session (current dir)",
    },
    {
      "<leader>QS",
      function()
        require("persistence").select()
      end,
      desc = "Select Session",
    },
    {
      "<leader>Ql",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "Restore Last Session",
    },
    {
      "<leader>Qd",
      function()
        require("persistence").stop()
      end,
      desc = "Don't Save Current Session",
    },
  },
}
