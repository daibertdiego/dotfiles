-- Define the rustaceanvim configuration
vim.g.rustaceanvim = function()
	-- Update this path
	local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = extension_path .. "lldb/lib/liblldb"
	local this_os = vim.uv.os_uname().sysname

	-- The path is different on Windows
	if this_os:find("Windows") then
		codelldb_path = extension_path .. "adapter\\codelldb.exe"
		liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
	else
		-- The liblldb extension is .so for Linux and .dylib for MacOS
		liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
	end

	local cfg = require("rustaceanvim.config")
	return {
		dap = {
			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		},
		server = {
			on_attach = function(client, bufnr)
				-- Keymaps

				vim.keymap.set("n", "<leader>ca", function()
					vim.cmd.RustLsp("codeAction")
				end, { silent = true, buffer = bufnr, desc = "Code Actions" })

				vim.keymap.set("n", "<leader>cR", function()
					vim.cmd.RustLsp("runnables")
					-- Move the buffer to a horizontal split below
					vim.cmd("wincmd J")
				end, { silent = true, buffer = bufnr, desc = "Run Runnables" })
			end,
			default_settings = {
				["rust-analyzer"] = {
					-- Add rust-analyzer specific configuration here
				},
			},
		},
	}
end
