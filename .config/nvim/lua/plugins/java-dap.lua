local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
	return
end

-- Determine OS
local home = vim.env.HOME
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason")
local launcher_path = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
if #launcher_path == 0 then
	launcher_path =
		vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]
end

local CONFIG = "linux"
if vim.fn.has("mac") == 1 then
	CONFIG = "mac"
elseif vim.fn.has("unix") ~= 1 then
	vim.notify("Unsupported system", vim.log.levels.ERROR)
	return
end

-- Workspace path
local WORKSPACE_PATH = home .. "/workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
	return
end

-- Test bundle
local bundles = { vim.fn.glob(mason_path .. "/packages/java-test/extension/server/*.jar", true) }
-- Debug bundle
local extra_bundles = vim.fn.glob(
	mason_path .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
	true
)
vim.list_extend(bundles, { extra_bundles })

-- JDTLS Configuration
local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. mason_path .. "/packages/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		launcher_path,
		"-configuration",
		mason_path .. "/packages/jdtls/config_" .. CONFIG,
		"-data",
		workspace_dir,
	},

	on_attach = function(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		vim.lsp.codelens.refresh()

		-- Keybindings for JDTLS with descriptions
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

	capabilities = require("cmp_nvim_lsp").default_capabilities(),

	root_dir = root_dir,

	settings = {
		java = {
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = { enabled = true },
			configuration = { updateDebounce = 500 },
			saveActions = { organizeImports = true },
		},
	},

	init_options = {
		bundles = bundles,
	},
}

print("Attempting to start JDTLS...")
jdtls.start_or_attach(config)

-- Auto-start JDTLS for Java files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.java",
	callback = function()
		print("Starting JDTLS for Java file...")
		jdtls.start_or_attach(config)
	end,
})
