vim.keymap.set({ "n", "v" }, "<C-Enter>", "<Plug>(DBUI_ExecuteQuery)", {
	silent = true,
	desc = "Execute Query in SQL buffer",
})
