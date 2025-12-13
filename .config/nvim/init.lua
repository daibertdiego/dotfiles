-- Enable DAP logging
require("options")
require("keymaps")
require("misc")
require("plugins.lazy")
require("plugins.mini")
require("plugins.colorscheme")
require("plugins.oilvim")
require("plugins.treesitter")
require("plugins.lualine")
require("plugins.harpoon")
require("plugins.colorizer")
require("plugins.web-tools")
require("plugins.codesnap") -- Lazy loaded by command, config not needed on startup
require("plugins.neogit")
require("plugins.gitsigns")
require("plugins.blink")
require("plugins.lsp")
require("plugins.goto-preview")
require("plugins.dap")
require("plugins.refactoring")
require("plugins.rustacean-nvim")
require("plugins.go-nvim")
require("plugins.dressing")
require("plugins.dashboard")
require("plugins.cloak")
require("plugins.dad-ui")
require("plugins.hurl")
require("plugins.codecompanion")
require("plugins.augment")
require("plugins.stay-centered")

-- Toggle Augment completions
vim.api.nvim_create_user_command("AugmentToggle", function()
	local current = vim.g.augment_disable_completions or 0
	if current == 0 then
		vim.g.augment_disable_completions = 1
		print("Augment completions disabled")
	else
		vim.g.augment_disable_completions = 0
		print("Augment completions enabled")
	end
end, {})
