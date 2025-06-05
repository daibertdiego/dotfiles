require("nvim-dap-virtual-text").setup()
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

vim.fn.sign_define("DapStopped", {
	text = "▶️",
	texthl = "DiagnosticSignWarn",
	linehl = "Visual",
	numhl = "DiagnosticSignWarn",
})

-- Debugger
vim.api.nvim_set_keymap(
	"n",
	"<leader>dt",
	":DapViewToggle<CR>",
	{ noremap = true, silent = true, desc = "Debug toggle UI" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>db",
	":DapToggleBreakpoint<CR>",
	{ noremap = true, silent = true, desc = "Debug toggle Breakpoint" }
)
vim.keymap.set("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { noremap = true, silent = true, desc = "Debug toggle Conditional Breakpoint" })
vim.api.nvim_set_keymap("n", "<leader>ds", ":DapContinue<CR>", { noremap = true, silent = true, desc = "Debut Start" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>dc",
	":DapTerminate<CR>",
	{ noremap = true, silent = true, desc = "Debug Cancel/Close" }
)
vim.keymap.set("n", "<leader>de", function()
	local word = vim.fn.expand("<cword>")
	if word and word ~= "" then
		vim.cmd("DapViewWatch " .. word)
	end
end, { noremap = true, silent = true, desc = "Add word under cursor to dap-view watch list" })

vim.api.nvim_set_keymap("n", "<leader>dr", ":DapViewOpen<CR>", { noremap = true, silent = true, desc = "Debug reset" })
vim.api.nvim_set_keymap(
	"n",
	"<F5>",
	"<cmd>lua require'dap'.step_back()<cr>",
	{ noremap = true, silent = true, desc = "Debug step back" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F7>",
	"<cmd>lua require'dap'.step_into()<cr>",
	{ noremap = true, silent = true, desc = "Debug step into" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F8>",
	"<cmd>lua require'dap'.step_over()<cr>",
	{ noremap = true, silent = true, desc = "Debug step over" }
)
vim.api.nvim_set_keymap(
	"n",
	"<F9>",
	"<cmd>lua require'dap'.run_to_cursor()<cr>",
	{ noremap = true, silent = true, desc = "Debug Run to cursor" }
)

-- local M = {}
-- M.config = function()
local dap = require("dap")
local dapview = require("dap-view")
dapview.setup({
	windows = {
		terminal = {
			-- Use the actual names for the adapters you want to hide
			hide = { "go" }, -- `go` is known to not use the terminal.
		},
	},
	winbar = {
		controls = {
			enabled = false,
			position = "right",
			buttons = {
				"play",
				"step_into",
				"step_over",
				"step_out",
				"step_back",
				"run_last",
				"terminate",
				"disconnect",
			},
			custom_buttons = {},
			icons = {
				pause = "",
				play = "",
				step_into = "",
				step_over = "",
				step_out = "",
				step_back = "",
				run_last = "",
				terminate = "",
				disconnect = "",
			},
		},
	},
})
-- Install golang specific config
require("dap-go").setup({
	delve = {
		path = "/Users/daibertdiego/go/bin/dlv",
		-- On Windows delve must be run attached or it crashes.
		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		detached = vim.fn.has("win32") == 0,
	},
})

-- require("mason-nvim-dap").setup({
-- 	-- Makes a best effort to setup the various debuggers with
-- 	-- reasonable debug configurations
-- 	automatic_installation = true, -- FIX: Looks like this is not installing automatically the adapters. Use :Mason DAP instead.
--
-- 	-- You can provide additional configuration to the handlers,
-- 	-- see mason-nvim-dap README for more information
-- 	handlers = {},
--
-- 	-- You'll need to check that you have the required things installed
-- 	-- online, please don't ask me how to install them :)
-- 	ensure_installed = {
-- 		-- Update this to ensure that you have the debuggers for the langs you want
-- 		"delve", -- GO and C
-- 		"codelldb", -- Rust
-- 		"javadbg", -- java-debug-adapter
-- 		"javatest",
-- 		"mock",
-- 		"kotlin",
-- 		"js",
-- 		"chrome",
-- 		"firefox",
-- 		"python",
-- 	},
-- })

-- Auto-open dap-view when debugging starts/stops (replaces dapui listeners)
dapview.setup()
dap.listeners.before.attach.dapui_config = function()
	dapview.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapview.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapview.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapview.close()
end

-- Check current debug status
vim.keymap.set("n", "<leader>dstatus", function()
	local session = require("dap").session()
	if session then
		if session.stopped_thread_id then
			print("STOPPED at breakpoint - ready for step commands")
			print("Use F7=step_into, F8=step_over, F9=run_to_cursor")
		else
			print("Running - not stopped")
		end
	else
		print("No debug session")
	end
end, { desc = "Check debug status" })

-- dap.adapters.go = function(callback, config)
-- 	if config.mode == "remote" and config.request == "attach" then
-- 		callback({
-- 			type = "server",
-- 			host = config.host or "127.0.0.1",
-- 			port = config.port or "38697",
-- 		})
-- 	else
-- 		callback({
-- 			type = "server",
-- 			port = "${port}",
-- 			executable = {
-- 				command = "dlv",
-- 				args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
-- 				detached = vim.fn.has("win32") == 0,
-- 			},
-- 		})
-- 	end
-- end
--
dap.configurations.go = {
	{
		type = "go",
		name = "Attach",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "go",
		name = "Debug Current File",
		request = "launch",
		program = "${file}",
	},
	{
		type = "go",
		name = "Debug (Arguments)",
		request = "launch",
		program = "${file}",
		args = function()
			local args_string = vim.fn.input("Arguments: ")
			return vim.split(args_string, " ", true)
		end,
	},
	{
		type = "go",
		name = "Debug (Arguments & Build Flags)",
		request = "launch",
		program = "${file}",
		buildFlags = function()
			return vim.fn.input("Build Flags: ")
		end,
		args = function()
			local args_string = vim.fn.input("Arguments: ")
			return vim.split(args_string, " ", true)
		end,
	},
	{
		type = "go",
		name = "Debug Package",
		request = "launch",
		program = "${fileDirname}",
	},
	{
		type = "go",
		name = "Debug test",
		request = "launch",
		mode = "test",
		program = "${file}",
	},
	{
		type = "go",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
	-- Your custom fts5 debug configs
	{
		type = "go",
		name = "Debug Go App (fts5 enabled)",
		request = "launch",
		mode = "exec",
		program = "${file}",
		buildFlags = "-tags=fts5",
		args = {},
	},
	{
		type = "go",
		name = "Debug Go Test (fts5 enabled)",
		request = "launch",
		mode = "test",
		program = "${fileDirname}",
		buildFlags = "-tags=fts5",
		args = {},
	},
}

--Java debugger adapter settings
dap.configurations.java = {
	-- {
	-- 	name = "Debug (Attach) - Remote",
	-- 	type = "java",
	-- 	request = "attach",
	-- 	hostName = "127.0.0.1",
	-- 	port = 5005,
	-- },
	{
		name = "Debug Cureent File",
		type = "java",
		request = "launch",
		program = "${file}",
	},
}
-- end

local dap = require("dap")
dap.adapters.kotlin = {
	type = "executable",
	command = "kotlin-debug-adapter",
	options = { auto_continue_if_many_stopped = false },
}

dap.configurations.kotlin = {
	{
		type = "kotlin",
		request = "launch",
		name = "This file",
		-- may differ, when in doubt, whatever your project structure may be,
		-- it has to correspond to the class file located at `build/classes/`
		-- and of course you have to build before you debug

		mainClass = function()
			local root = vim.fs.find("src", { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1] or ""
			local fname = vim.api.nvim_buf_get_name(0)
			-- src/main/kotlin/websearch/Main.kt -> websearch.MainKt
			return fname:gsub(root, ""):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", "."):sub(2, -1)
		end,

		projectRoot = "${workspaceFolder}",
		jsonLogFile = "",
		enableJsonLogging = false,
	},
	{
		-- Use this for unit tests
		-- First, run
		-- ./gradlew --info cleanTest test --debug-jvm
		-- then attach the debugger to it
		type = "kotlin",
		request = "attach",
		name = "Attach to debugging session",
		port = 5005,
		args = {},
		projectRoot = vim.fn.getcwd,
		hostName = "localhost",
		timeout = 2000,
	},
}

---- Add this to see debug output
require("dap").set_log_level("DEBUG")
