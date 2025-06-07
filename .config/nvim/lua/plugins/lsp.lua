-- lsp.lua
-- Setup diagnostics signs (modern way)
local icons = require("lib.icons").diagnostics
local signs = {
	Error = icons.Error,
	Warn = icons.Warning,
	Hint = icons.Hint,
	Info = icons.Information,
}

-- Modern diagnostic config (replaces deprecated sign_define)
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
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

-- Global diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

-- Define LSP keymaps
local function on_attach(_, bufnr)
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
	nmap("K", require("pretty_hover").hover, "Hover Doc")
	nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
	nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
	nmap("<leader>cs", function()
		require("telescope.builtin").lsp_document_symbols()
	end, "Document Symbols")
	nmap("<leader>ws", function()
		require("telescope.builtin").lsp_dynamic_workspace_symbols()
	end, "Workspace Symbols")
	nmap("gj", vim.diagnostic.goto_next, "Next Diagnostic")
	nmap("gk", vim.diagnostic.goto_prev, "Prev Diagnostic")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "List Workspace Folders")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
		vim.lsp.buf.format()
	end, { desc = "Format current buffer" })
end

-- Capabilities from cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.g.augment_disable_completions = 0

-- List of servers (fixed tsserver -> ts_ls)
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
	"tailwindcss",
	"kotlin_language_server",
	"typos_lsp",
	"bashls",
}

-- Setup mason and mason-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = false,
})

-- Setup LSP servers individually (replaces setup_handlers)
local lspconfig = require("lspconfig")

-- Default setup for most servers
for _, server in ipairs(servers) do
	if server ~= "lua_ls" then -- Handle lua_ls separately
		lspconfig[server].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end
end

-- Special setup for lua_ls
lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Hover window border
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})

-- Modern LSP start for bash
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.lsp.start({
			name = "bash-language-server",
			cmd = { "bash-language-server", "start" },
			root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]) or vim.fn.getcwd(),
		})
	end,
})
