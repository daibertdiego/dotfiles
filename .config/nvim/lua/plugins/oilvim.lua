local oil = require("oil")

oil.setup({
	prompt_save_on_select_new_entry = false,
	skip_confirm_for_simple_edits = true,
	watch_for_changes = true,
	show_hidden = true,
	view_options = {
		show_hidden = true,
	},
	preview = {
		enabled = true,
		width = 60,
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

vim.keymap.set("n", "<leader>-", function()
	local util = require("oil.util")
	oil.open()
	util.run_after_load(0, function()
		oil.open_preview()
	end)
end, { desc = "Open parent directory" })
