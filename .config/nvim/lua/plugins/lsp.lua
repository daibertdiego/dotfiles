-- Diagnostics
local icons = require("lib.icons").diagnostics
local signs = {
	Error = icons.Error,
	Warn = icons.Warning,
	Hint = icons.Hint,
	Info = icons.Information,
}

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.INFO] = signs.Info,
			[vim.diagnostic.severity.HINT] = signs.Hint,
		},
	},
	virtual_text = false,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = true, header = "", prefix = "" },
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

-- Load shared LSP options
local opts = require("plugins.lsp.opts")

vim.g.augment_disable_completions = 0

-- Servers (jdtls handled by nvim-java)
local servers = {
	"clangd",
	"lua_ls",
	"pyright",
	"ts_ls",
	"gopls",
	"dockerls",
	"texlab",
	"yamlls",
	"emmet_ls",
	"html",
	"angularls",
	"tailwindcss",
	"kotlin_language_server",
	"typos_lsp",
	"bashls",
}

-- Mason (install binaries)
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = false,
	handlers = {
		-- Default handler for all servers
		function(server_name)
			-- Skip jdtls - handled by ftplugin/java.lua
			if server_name == "jdtls" then
				return
			end
			-- Let vim.lsp.config/enable handle it below
		end,
	},
})

-- Default config for all servers
vim.lsp.config("*", {
	capabilities = opts.capabilities,
	on_attach = opts.on_attach,
})

-- Define per-server configs using modular settings
for _, server in ipairs(servers) do
	-- Try to load server-specific settings
	local ok, settings = pcall(require, "plugins.lsp.settings." .. server)
	if ok then
		-- Merge server-specific settings with defaults
		vim.lsp.config(server, settings)
	end
end

-- Enable (autostart) servers (skip jdtls - it's in ftplugin/java.lua)
for _, server in ipairs(servers) do
	if server ~= "jdtls" then
		vim.lsp.enable(server)
	end
end

-- UI: rounded hover
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
