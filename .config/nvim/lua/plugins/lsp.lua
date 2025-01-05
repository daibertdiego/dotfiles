local icons = require("lib.icons").diagnostics

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- LSP settings
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gt", vim.lsp.buf.type_definition, "[G]o to [T]ype Definition")
	nmap("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[C]ode Document [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		elseif vim.lsp.buf.formatting then
			vim.lsp.buf.formatting()
		end
	end, { desc = "Format current buffer with LSP" })
end

-- Setup mason
require("mason").setup()

-- Language servers to install
local servers = {
	-- "jdtls", -- This should be installed manually and follow a separated config flow.
	"clangd",
	"lua_ls",
	-- "rust_analyzer", -- This is already being installed by rustaciannvim plugin.
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
}

-- Ensure servers are installed
require("mason-lspconfig").setup({
	ensure_installed = servers,
})

-- nvim-cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities()

local signs = { Error = icons.Error, Warn = icons.Warning, Hint = icons.Hint, Info = icons.Information }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Setup LSP for all servers
for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Custom configuration for 'jdtls'
local lspconfig = require("lspconfig")
local home = vim.env.HOME
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason")
local launcher_path = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

local CONFIG = vim.fn.has("mac") == 1 and "mac" or "linux"
local WORKSPACE_PATH = home .. "/workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = lspconfig.util.root_pattern(unpack(root_markers))
if not root_dir then
	return
end

local bundles = { vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar", true) }
local extra_bundles = vim.fn.glob(
	mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
	true
)
vim.list_extend(bundles, { extra_bundles })

-- Setup LSP for jdtls
lspconfig.jdtls.setup({
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-jar",
		launcher_path,
		"-configuration",
		mason_path .. "/packages/jdtls/config_" .. CONFIG,
		"-data",
		workspace_dir,
	},
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		vim.lsp.codelens.refresh()

		-- Keybindings for JDTLS
		vim.api.nvim_set_keymap(
			"n",
			"<leader>co",
			"<Cmd>lua require'jdtls'.organize_imports()<CR>",
			{ noremap = true, silent = true, desc = "Organize imports" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>cv",
			"<Cmd>lua require'jdtls'.extract_variable()<CR>",
			{ noremap = true, silent = true, desc = "Extract variable" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>cc",
			"<Cmd>lua require'jdtls'.extract_constant()<CR>",
			{ noremap = true, silent = true, desc = "Extract constant" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ct",
			"<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
			{ noremap = true, silent = true, desc = "Test nearest method" }
		)
	end,
	capabilities = capabilities,
	root_dir = root_dir,
	settings = {
		java = {
			configuration = { updateDebounce = 500 },
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = { enabled = true },
			saveActions = { organizeImports = true },
		},
	},
	init_options = {
		bundles = bundles,
	},
})

-- Auto-start JDTLS for Java files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.java",
	callback = function()
		lspconfig.jdtls.start_or_attach({ root_dir = root_dir })
	end,
})

-- Turn on LSP status information
require("fidget").setup()

-- Lua LSP configuration
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			format = { enable = true },
			runtime = { version = "LuaJIT", path = runtime_path },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

-- Bash Language Server
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.lsp.start({
			name = "bash-language-server",
			cmd = { "bash-language-server", "start" },
		})
	end,
})
