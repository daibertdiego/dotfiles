local oil = require("oil")
oil.setup({
	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
	prompt_save_on_select_new_entry = false,
	-- Show hidden files by default
	show_hidden = true,
	-- Enable file preview
	view_options = {
		-- Show previewer
		show_hidden = true,
	},
	-- Preview window configuration
	preview = {
		-- Width of preview window (percentage or absolute value)
		width = 60,
		-- Height of preview window (percentage or absolute value)
		height = 40,
	},
	keymaps = {
		["<C-p>"] = {
			callback = function()
				local oil = require("oil")
				oil.open_preview({ vertical = true, split = "botright" })
			end,
		},
	},
})

vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
