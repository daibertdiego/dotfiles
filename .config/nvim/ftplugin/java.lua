-- Simplified Java JDTLS configuration
-- All Java version logic is centralized in lua/plugins/lsp/settings/jdtls.lua

-- Guard: prevent multiple loads
if vim.b.jdtls_ftplugin_loaded then
	return
end
vim.b.jdtls_ftplugin_loaded = true

local jdtls = require("jdtls")
local jdtls_config = require("plugins.lsp.settings.jdtls")

-- Block vim.lsp.start for JDTLS with nil root_dir (prevents vim.lsp.enable auto-start)
local original_lsp_start = vim.lsp.start
vim.lsp.start = function(config, opts)
	if config and config.name == "jdtls" and not config.root_dir then
		return nil
	end
	return original_lsp_start(config, opts)
end

-- Helper: find project root
local function project_root()
	local buf = vim.api.nvim_buf_get_name(0)
	local markers = { "pom.xml", "build.gradle", "settings.gradle", "mvnw", "gradlew", ".git" }
	local found = vim.fs.find(markers, { path = buf, upward = true })[1]
	if found then
		local root = vim.fs.dirname(found)
		if root:match("/(bin|target|build)$") then
			root = vim.fs.dirname(root)
		end
		return root
	end
	local src_dir = vim.fs.find("src", { path = buf, upward = true, type = "directory" })[1]
	if src_dir then
		return vim.fs.dirname(src_dir)
	end
	return vim.loop.cwd()
end

-- Resolve paths
local root_dir = vim.fn.fnamemodify(project_root(), ":p")
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspace/" .. project_name
workspace_dir = vim.fn.fnamemodify(workspace_dir, ":p")
vim.fn.mkdir(workspace_dir, "p")

-- Single-instance guard (per-root, race-safe)
for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls", bufnr = 0 })) do
	if client.config.root_dir == root_dir then
		return
	end
end

for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
	if client.config.root_dir == root_dir then
		vim.lsp.buf_attach_client(0, client.id)
		return
	end
	if client.config.root_dir ~= root_dir then
		client.stop()
	end
end

-- DAP/Test bundles (Mason)
local mason = vim.fn.stdpath("data") .. "/mason/packages"
local function globs(pat)
	return vim.split(vim.fn.glob(pat), "\n", { trimempty = true })
end
local bundles = {}
vim.list_extend(bundles, globs(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"))
vim.list_extend(bundles, globs(mason .. "/java-test/extension/server/*.jar"))

-- Add annotation processor JARs from .factorypath
local factorypath = root_dir .. "/.factorypath"
if vim.fn.filereadable(factorypath) == 1 then
	local content = table.concat(vim.fn.readfile(factorypath), "\n")
	for jar in content:gmatch('id="([^"]*%.jar)"') do
		if vim.fn.filereadable(jar) == 1 then
			table.insert(bundles, jar)
		end
	end
end

-- Global code action deduplication
if not _G.jdtls_code_action_handler_set then
	_G.jdtls_code_action_handler_set = true
	local original_handler = vim.lsp.handlers["textDocument/codeAction"]

	vim.lsp.handlers["textDocument/codeAction"] = function(err, result, ctx, config)
		if result and not vim.tbl_isempty(result) then
			local seen = {}
			local unique = {}
			for _, action in ipairs(result) do
				local title = action.title or ""
				if not seen[title] then
					seen[title] = true
					table.insert(unique, action)
				end
			end
			result = unique
		end
		return original_handler(err, result, ctx, config)
	end
end

-- on_attach
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
	nmap("K", vim.lsp.buf.hover, "Hover Doc")

	nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
	nmap("<leader>cd", function()
		local clients = vim.lsp.get_clients({ bufnr = 0, name = "jdtls" })
		print("JDTLS clients attached: " .. #clients)
		for i, client in ipairs(clients) do
			print(i .. ": " .. client.name .. " (id=" .. client.id .. ", root=" .. client.config.root_dir .. ")")
		end
	end, "Debug: Show JDTLS clients")
	nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
	nmap("<leader>cA", function()
		vim.lsp.buf.code_action({ context = { only = { "source" } } })
	end, "Source Actions (Generate)")
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
		require("conform").format({ bufnr = bufnr })
	end, { desc = "Format current buffer" })

	-- DAP run/debug main
	vim.api.nvim_buf_create_user_command(bufnr, "JdtRunMain", function()
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()
		require("dap").continue()
	end, { desc = "Run Java main (DAP)" })
	vim.keymap.set("n", "<leader>ds", function()
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()
		require("dap").continue()
	end, { buffer = bufnr, desc = "Java: Debug main" })

	-- Test commands
	nmap("<leader>tc", function()
		require("jdtls").test_class()
	end, "Test: Run class")
	nmap("<leader>tm", function()
		require("jdtls").test_nearest_method()
	end, "Test: Run method at cursor")
	nmap("<leader>td", function()
		require("jdtls").pick_test()
	end, "Test: Debug (pick)")

	vim.api.nvim_buf_create_user_command(bufnr, "JdtTestClass", function()
		require("jdtls").test_class()
	end, { desc = "Run all tests in current class" })
	vim.api.nvim_buf_create_user_command(bufnr, "JdtTestMethod", function()
		require("jdtls").test_nearest_method()
	end, { desc = "Run test method at cursor" })
	vim.api.nvim_buf_create_user_command(bufnr, "JdtTestDebug", function()
		require("jdtls").pick_test()
	end, { desc = "Pick and debug test" })
end

-- Capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Find Lombok JAR from project
local function find_lombok_jar()
	local factorypath = root_dir .. "/.factorypath"
	if vim.fn.filereadable(factorypath) == 1 then
		local content = table.concat(vim.fn.readfile(factorypath), "\n")
		local jar = content:match('id="([^"]*lombok[^"]*%.jar)"')
		if jar and vim.fn.filereadable(jar) == 1 then
			return jar
		end
	end
	return nil
end

local lombok_jar = find_lombok_jar()

-- Build JDTLS command (use Java 21 for JDTLS server)
local cmd = {
	jdtls_config.JDTLS_JAVA_BIN,
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xmx1g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
}

-- Add Lombok javaagent if found
if lombok_jar then
	table.insert(cmd, "-javaagent:" .. lombok_jar)
end

vim.list_extend(cmd, {
	"-jar",
	vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
	"-configuration",
	vim.fn.stdpath("data")
		.. "/mason/packages/jdtls/config_"
		.. (vim.fn.has("mac") == 1 and "mac" or "linux"),
	"-data",
	workspace_dir,
})

-- Start JDTLS
local cfg = {
	cmd = cmd,
	root_dir = root_dir,
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = { bundles = bundles },
	settings = jdtls_config.settings,
}

jdtls.start_or_attach(cfg)
