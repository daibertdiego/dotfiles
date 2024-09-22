vim.keymap.set("x", "<leader>cf", ":Refactor extract ", { desc = "Code refactor extract function" })
vim.keymap.set("n", "<leader>cF", ":Refactor inline_func", { desc = "Code Refactor inline function" })

vim.keymap.set("x", "<leader>ce", ":Refactor extract_to_file ", { desc = "Code refactor extract function to file" })

vim.keymap.set("x", "<leader>cv", ":Refactor extract_var ", { desc = "Code refactor extract variable" })

vim.keymap.set({ "n", "x" }, "<leader>cV", ":Refactor inline_var", { desc = "Code refactor inline variable" })

-- vim.keymap.set("n", "<leader>cb", ":Refactor extract_block")
-- vim.keymap.set("n", "<leader>cB", ":Refactor extract_block_to_file")

-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.keymap.set("n", "<leader>dp", function()
	require("refactoring").debug.printf({ below = false })
end, { desc = "Debug printf" })

-- Print var
vim.keymap.set({ "x", "n" }, "<leader>dv", function()
	require("refactoring").debug.print_var()
end, { desc = "Debug print variable" })
-- Supports both visual and normal mode

vim.keymap.set("n", "<leader>dC", function()
	require("refactoring").debug.cleanup({})
end, { desc = "Debug cleanup prints." })
-- Supports only normal mode
