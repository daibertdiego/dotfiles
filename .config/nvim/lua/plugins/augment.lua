-- ~/.config/nvim/lua/plugins/augment.lua
-- Load augment.nvim
require("augment") -- Ensure plugin is loaded

-- Key mappings using <Cmd> to avoid context issues
vim.keymap.set("i", "<C-y>", "<Cmd>call augment#Accept()<CR>", {
	noremap = true,
	silent = true,
	desc = "Accept augment.nvim suggestion",
})

-- Set workspace folders (if supported)
vim.g.augment_workspace_folders = {
	"~/Projects/vault-backend-v4",
	"~/Projects/vault-frontend-v4",
	"~/Projects/vault-v4-db-migration",
}
