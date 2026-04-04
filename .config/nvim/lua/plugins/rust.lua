return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  lazy = false, -- This plugin is already lazy
  server = {
    on_attach = function(client, bufnr)
    end,
    default_settings = {
      ['rust-analyzer'] = {
        inlay_hints = {
          enabled = true,
        },
      },
    },
    cmd_env = {
      CARGO_TARGET_DIR = 'target/ra',
    },
  },
}
