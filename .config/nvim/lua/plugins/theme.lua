return {
  {
    '0xstepit/flow.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'flow'
    end,
    config = function()
      require('flow').setup_options {
        transparent = true,
        mode = 'light',
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
