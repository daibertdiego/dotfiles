require("dapui").setup()
require("dap-go").setup()

require("nvim-dap-virtual-text").setup()
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

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

local M = {}
M.config = function()
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
end

return M
