return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  keymaps = {
    ['<C-n>'] = 'actions.cd',
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
}
