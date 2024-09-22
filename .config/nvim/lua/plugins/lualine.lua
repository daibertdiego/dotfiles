require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'codedark',
    section_separators = { left = ' ', right = ' ' },
    component_separators = { left = ' ', right = ' ' }, 
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {'encoding', 'fileformat', 'filetype', { 'filename', path = 1 } }, -- Show relative path
    lualine_x = {
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
        color = { fg = "#ff9e64" },
      },
      {
        require("noice").api.status.command.get,
        cond = require("noice").api.status.command.has,
        color = { fg = "#ff9e64" },
      },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }
}

