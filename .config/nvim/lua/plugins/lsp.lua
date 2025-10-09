-- Diagnostics (unchanged)
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

-- on_attach (unchanged)
local function on_attach(client, bufnr)
	local nmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc and "LSP: " .. desc })
	end

	nmap("gd", vim.lsp.buf.definition, "Goto Definition")
	nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
	nmap("gr", function()
		require("telescope.builtin").lsp_references()
	end, "Goto References")
	nmap("gI", vim.lsp.buf.implementation, "Goto Implementation")
	nmap("gt", vim.lsp.buf.type_definition, "Goto Type Definition")
	nmap("gj", vim.diagnostic.goto_next, "Next Diagnostic")
	nmap("gk", vim.diagnostic.goto_prev, "Prev Diagnostic")

	-- Skip hover setup for jdtls (handled in ftplugin/java.lua)
	if client.name ~= "jdtls" then
		nmap("K", require("pretty_hover").hover, "Hover Doc")
	end

	nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
	nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
	nmap("<leader>cs", function()
		require("telescope.builtin").lsp_document_symbols()
	end, "Document Symbols")
	nmap("<leader>ws", function()
		require("telescope.builtin").lsp_dynamic_workspace_symbols()
	end, "Workspace Symbols")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "List Workspace Folders")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		vim.lsp.buf.format()
	end, { desc = "Format current buffer" })
end

-- Capabilities (unchanged)
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.g.augment_disable_completions = 0

-- Servers
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

-- Helper: root dir like lspconfig.util.root_pattern, but via vim.fs
local function root_by_markers(markers, startpath)
	local found = vim.fs.find(markers, { path = startpath or vim.api.nvim_buf_get_name(0), upward = true })[1]
	return found and vim.fs.dirname(found) or vim.loop.cwd()
end

-- Define per-server configs using the new API
for _, server in ipairs(servers) do
	if server == "lua_ls" then
		vim.lsp.config("lua_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})
	else
		vim.lsp.config(server, {
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end
end

-- Enable (autostart) servers (skip jdtls - it's in ftplugin/java.lua)
for _, server in ipairs(servers) do
	if server ~= "jdtls" then
		vim.lsp.enable(server)
	end
end

-- Note: JDTLS is blocked in ftplugin/java.lua to prevent vim.lsp.enable auto-start

-- UI: rounded hover (unchanged)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

-- NOTE: you had a FileType autocmd to manually start bash LSP.
-- Since 'bashls' is now in `servers` and enabled above, that autocmd is no longer needed.
