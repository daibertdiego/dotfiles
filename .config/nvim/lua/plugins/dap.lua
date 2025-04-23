require("dapui").setup()
require("dap-go").setup()

require("nvim-dap-virtual-text").setup()
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

vim.fn.sign_define("DapStopped", { text = "➡", texthl = "Warning", linehl = "CursorLine", numhl = "" })

-- Debugger
vim.api.nvim_set_keymap(
	"n",
	"<leader>dt",
	":DapUiToggle<CR>",
	{ noremap = true, silent = true, desc = "Debug toogle UI" }
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
	":DapStop<CR>",
	{ noremap = true, silent = true, desc = "Debut Cancel/Close" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>de",
	"<cmd>lua require('dapui').eval()<cr><cmd>lua require('dapui').eval()<cr>",
	{ noremap = true, silent = true, desc = "Eval" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>dr",
	":lua require('dapui').open({reset = true})<CR>",
	{ noremap = true, silent = true, desc = "Debug reset" }
)
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
local dapui = require("dapui")

require("mason-nvim-dap").setup({
	-- Makes a best effort to setup the various debuggers with
	-- reasonable debug configurations
	automatic_installation = true, -- FIX: Looks like this is not installing automatically the adapters. Use :Mason DAP instead.

	-- You can provide additional configuration to the handlers,
	-- see mason-nvim-dap README for more information
	handlers = {},

	-- You'll need to check that you have the required things installed
	-- online, please don't ask me how to install them :)
	ensure_installed = {
		-- Update this to ensure that you have the debuggers for the langs you want
		"delve", -- GO and C
		"codelldb", -- Rust
		"javadbg", -- java-debug-adapter
		"javatest",
		"mock",
		"kotlin",
		"js",
		"chrome",
		"firefox",
		"python",
	},
})

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup({
	-- Set icons to characters that are more likely to work in every terminal.
	--    Feel free to remove or use ones that you like more! :)
	--    Don't feel like these are good choices.
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Install golang specific config
require("dap-go").setup({
	delve = {
		-- On Windows delve must be run attached or it crashes.
		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		detached = vim.fn.has("win32") == 0,
	},
})

dap.configurations.go = {
	-- Default Go debug configs
	{
		type = "go",
		name = "Attach",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "go",
		name = "Debug",
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
-- return M
