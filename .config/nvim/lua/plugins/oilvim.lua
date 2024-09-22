local oil = require("oil")
oil.setup({
  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  -- (:help prompt_save_on_select_new_entry)
prompt_save_on_select_new_entry = false,
keymaps = {
  ['<C-p>'] = {
    callback = function()
      local oil = require 'oil'
      oil.open_preview { vertical = true, split = 'botright' }
    end,
  },
},
})

vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- -- Ensure you require which-key
-- local wk = require("which-key")

-- -- Define the mappings for your keybindings
-- wk.register({
--   ["-"] = { "<cmd>OilOpen<CR>", "Open parent directory using oilvim" }
-- }, {
--   mode = "n", -- normal mode
--   prefix = "<leader>", -- prefix for the mappings
--   buffer = nil, -- buffer-specific keybindings
--   silent = true, -- use silent mode
--   noremap = true, -- non-recursive mappings
--   nowait = false, -- whether or not to wait for key sequences
-- })
