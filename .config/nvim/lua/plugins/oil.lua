return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  keymaps = {
    ['<C-n>'] = 'actions.cd',
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    columns = {
      'icon',
    },
  },
}
