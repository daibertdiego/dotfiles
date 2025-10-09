-- ~/.config/nvim/ftplugin/java.lua

-- IMMEDIATE guard: prevent multiple loads
if vim.b.jdtls_ftplugin_loaded then
	return
end
vim.b.jdtls_ftplugin_loaded = true

local jdtls = require("jdtls")

-- Block vim.lsp.start for JDTLS with nil root_dir (prevents vim.lsp.enable auto-start)
local original_lsp_start = vim.lsp.start
vim.lsp.start = function(config, opts)
	if config and config.name == "jdtls" and not config.root_dir then
		-- Block the auto-start from vim.lsp.enable which has no root_dir
		return nil
	end
	return original_lsp_start(config, opts)
end

-- ---------------- helpers ----------------
local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

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

local function detect_java_home()
	if vim.env.JAVA_HOME and #vim.env.JAVA_HOME > 0 then
		return trim(vim.env.JAVA_HOME)
	end
	local lines = vim.fn.systemlist("java -XshowSettings:properties -version 2>&1")
	for _, line in ipairs(lines) do
		local path = line:match("^%s*java%.home%s*=%s*(.+)$")
		if path then
			return trim(path)
		end
	end
end

local function detect_java_major_version()
	local out = table.concat(vim.fn.systemlist("java -version 2>&1"), "\n")
	local ver = out:match('version%s+"(%d+)[%._]') or out:match("openjdk%s+(%d+)[%._]")
	return ver and tonumber(ver) or nil
end

local function runtime_name_from_major(major)
	return major and ("JavaSE-%d"):format(major) or "JavaSE"
end

-- ---------------- resolve paths ----------------
local root_dir = vim.fn.fnamemodify(project_root(), ":p") -- absolute
local has_maven = (vim.fn.filereadable(root_dir .. "/pom.xml") == 1)
local has_gradle = (vim.fn.filereadable(root_dir .. "/build.gradle") == 1)
	or (vim.fn.filereadable(root_dir .. "/build.gradle.kts") == 1)

-- workspace via -data (NEVER in init_options)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspace/" .. project_name
workspace_dir = vim.fn.fnamemodify(workspace_dir, ":p")
vim.fn.mkdir(workspace_dir, "p")

-- ---------------- single-instance guard (per-root, race-safe) ----------------
-- Check if JDTLS is already running for this root
for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls", bufnr = 0 })) do
	if client.config.root_dir == root_dir then
		-- Already attached to this buffer for this root
		return
	end
end

-- Check if JDTLS is running for this root in ANY buffer
for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
	if client.config.root_dir == root_dir then
		-- Already running for this root, just attach
		vim.lsp.buf_attach_client(0, client.id)
		return
	end
	-- Stop clients for different roots
	if client.config.root_dir ~= root_dir then
		client.stop()
	end
end

-- ---------------- runtime (SDKMAN) ----------------
local JAVA_HOME = detect_java_home()
if not JAVA_HOME then
	vim.notify(
		"[jdtls] JAVA_HOME not found. Start Neovim from a shell where SDKMAN set it, or `sdk default java`.",
		vim.log.levels.WARN
	)
end
JAVA_HOME = JAVA_HOME and vim.fn.fnamemodify(JAVA_HOME, ":p") or nil
local runtime_name = runtime_name_from_major(detect_java_major_version())

-- ---------------- DAP/Test bundles (Mason) ----------------
local mason = vim.fn.stdpath("data") .. "/mason/packages"
local function globs(pat)
	return vim.split(vim.fn.glob(pat), "\n", { trimempty = true })
end
local bundles = {}
vim.list_extend(bundles, globs(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"))
vim.list_extend(bundles, globs(mason .. "/java-test/extension/server/*.jar"))

-- ---------------- Global code action deduplication ----------------
-- Set this ONCE globally before any client starts
if not _G.jdtls_code_action_handler_set then
	_G.jdtls_code_action_handler_set = true
	local original_handler = vim.lsp.handlers["textDocument/codeAction"]

	vim.lsp.handlers["textDocument/codeAction"] = function(err, result, ctx, config)
		if result and not vim.tbl_isempty(result) then
			-- Deduplicate based on title
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

-- ---------------- on_attach ----------------
local function on_attach(client, bufnr)
	local nmap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc and "LSP: " .. desc })
	end

	-- Setup basic keybindings
	nmap("gd", vim.lsp.buf.definition, "Goto Definition")
	nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
	nmap("gr", function()
		require("telescope.builtin").lsp_references()
	end, "Goto References")
	nmap("gI", vim.lsp.buf.implementation, "Goto Implementation")
	nmap("gt", vim.lsp.buf.type_definition, "Goto Type Definition")
	nmap("gj", vim.diagnostic.goto_next, "Next Diagnostic")
	nmap("gk", vim.diagnostic.goto_prev, "Prev Diagnostic")

	-- Use standard hover for Java (pretty_hover disabled for java filetype)
	nmap("K", vim.lsp.buf.hover, "Hover Doc")

	nmap("<leader>cr", vim.lsp.buf.rename, "Rename")
	-- Debug: check how many JDTLS clients are attached
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
	vim.keymap.set("n", "<leader>cR", "<cmd>JdtRunMain<CR>", { buffer = bufnr, desc = "Java: Run main" })
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

	-- Test commands as Ex commands
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

-- ---------------- capabilities ----------------
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- ---------------- settings (switch depending on build tool presence) ----------------
local java_settings

if has_maven or has_gradle then
	-- Build tool present: let JDTLS use its Maven/Gradle providers (enables DAP classpath)
	java_settings = {
		configuration = {
			runtimes = (function()
				if not JAVA_HOME then
					return nil
				end
				return { { name = runtime_name, path = JAVA_HOME } }
			end)(),
			updateBuildConfiguration = "interactive", -- or "automatic"
		},
		import = {
			maven = { enabled = has_maven }, -- true only if pom.xml exists
			gradle = { enabled = has_gradle }, -- true only if build.gradle(.kts) exists
		},
		maven = { downloadSources = true },
		eclipse = { downloadSources = true },
		format = {
			enabled = true,
			settings = {
				url = vim.fn.stdpath("data") .. "/mason/packages/google-java-format/google-java-format.jar",
				profile = "Google",
			},
		},
	}
else
	-- NO build file: disable Maven/Gradle providers to avoid m2e error; give simple project hints
	java_settings = {
		configuration = {
			runtimes = (function()
				if not JAVA_HOME then
					return nil
				end
				return { { name = runtime_name, path = JAVA_HOME } }
			end)(),
			updateBuildConfiguration = "disabled",
		},
		import = {
			maven = { enabled = false },
			gradle = { enabled = false },
		},
		project = {
			-- keep minimal; you can uncomment to help JDTLS:
			sourcePaths = { "src/main/java", "src/test/java" },
			-- referencedLibraries = { "lib/**/*.jar" },
		},
		format = {
			enabled = true,
			settings = {
				url = vim.fn.stdpath("data") .. "/mason/packages/google-java-format/google-java-format.jar",
				profile = "Google",
			},
		},
	}
end

-- ---------------- cmd (-data only) ----------------
local cmd = { "jdtls", "-data", workspace_dir }
-- To force Mason's jdtls binary, uncomment:
-- local mason_registry = require("mason-registry")
-- if mason_registry.has_package("jdtls") then
--   local jdtls_pkg = mason_registry.get_package("jdtls")
--   cmd = { jdtls_pkg:get_install_path() .. "/bin/jdtls", "-data", workspace_dir }
-- end

-- ---------------- start_or_attach ----------------
local cfg = {
	cmd = cmd,
	root_dir = root_dir,
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = { bundles = bundles },
	settings = { java = java_settings },
}
jdtls.start_or_attach(cfg)
