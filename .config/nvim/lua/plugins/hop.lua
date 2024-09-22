-- place this in one of your configuration file(s)
local hop = require('hop')
local directions = require('hop.hint').HintDirection
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "s", ":HopChar2MW<cr>", opts)
vim.api.nvim_set_keymap("n", "S", ":HopWordMW<cr>", opts)
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, opts)
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })
