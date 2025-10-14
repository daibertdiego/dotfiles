local M = {}

-- Capabilities for LSP
M.capabilities = require("blink.cmp").get_lsp_capabilities()

-- Keymaps attached to LSP buffers
M.on_attach = function(client, bufnr)
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

return M
