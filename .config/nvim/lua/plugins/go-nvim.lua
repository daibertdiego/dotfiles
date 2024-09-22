-- Use an autocommand to set up keymaps only for Go files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		-- Define your keymaps for Go files
		vim.keymap.set("n", "<leader>cR", ":GoRun<CR>", { buffer = true, silent = true, desc = "Go Run main" })
		vim.keymap.set(
			"n",
			"<leader>ct",
			":GoAddTag<CR>",
			{ buffer = true, silent = true, desc = "Go Add Tags to struct" }
		)
		-- Insert if err != nil in Golang files
		vim.keymap.set(
			"n",
			"<leader>er",
			":GoIfErr<CR>",
			{ buffer = true, silent = true, noremap = true, desc = "Insert Go if err != nil" }
		)
	end,
})
