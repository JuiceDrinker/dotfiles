local function set_highlights()
  local groups = {
    -- Keep Flow's syntax palette, but make structural UI surfaces easier to read.
    Comment = { fg = '#657B89', italic = true },
    CursorLine = { bg = '#223039' },
    FloatBorder = { fg = '#6E8798' },
    LineNr = { fg = '#526A78' },
    NormalFloat = { bg = '#192329', fg = '#D1DBE0' },
    WinSeparator = { fg = '#314552' },

    Directory = { fg = '#8FA3FF' },
    OilDir = { fg = '#8FA3FF' },
    OilDirIcon = { fg = '#8FA3FF' },

    SnacksPickerComment = { fg = '#657B89', italic = true },
    SnacksPickerDesc = { fg = '#7F95A3' },
    SnacksPickerDimmed = { fg = '#6D8391' },
    SnacksPickerDir = { fg = '#7F95A3' },
    SnacksPickerListCursorLine = { bg = '#26343D' },
    SnacksPickerPathHidden = { fg = '#6D8391' },
    SnacksPickerPathIgnored = { fg = '#5F7280' },
    SnacksPickerTree = { fg = '#526A78' },
  }

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

set_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Reapply local visual contrast tweaks',
  group = vim.api.nvim_create_augroup('adi-visual-contrast', { clear = true }),
  callback = set_highlights,
})
