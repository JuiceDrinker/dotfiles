return {
  'olimorris/codecompanion.nvim',
  keys = {
    { '<leader>cc', '<cmd>CodeCompanionChat Toggle<CR>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Toggle chat', silent = true },
    { '<leader>ci', '<cmd>CodeCompanionInline<CR>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Inline edit', silent = true },
    { '<leader>ca', '<cmd>CodeCompanionActions<CR>', mode = { 'n', 'v' }, desc = 'CodeCompanion: Actions', silent = true },
  },
  opts = {
    strategies = {
      chat = {
        adapter = 'anthropic',
      },
      inline = {
        adapter = 'anthropic',
      },
      agent = {
        adapter = 'anthropic',
      },
    },
    display = {
      chat = {
        show_settings = true,
      },
    },
    adapters = {
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = 'ANTHROPIC_API_KEY',
          },
        })
      end,
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = {
            api_key = 'OPENAI_API_KEY',
          },
          schema = {
            model = {
              default = 'o3-2025-04-16',
            },
          },
        })
      end,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    {
      'stevearc/dressing.nvim',
      opts = {},
    },
    'nvim-treesitter/nvim-treesitter',
  },
}
