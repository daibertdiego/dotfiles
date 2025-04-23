require("mini.animate").setup({
	-- Window open
	open = {
		enable = false,
	},

	-- Window close
	close = {
		enable = false,
	},
})
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.surround").setup()
require("mini.jump").setup()
require("mini.jump2d").setup({
	mappings = {
		start_jumping = "<leader>j",
	},
})
require("mini.comment").setup({
	mappings = {
		comment = "<leader>/",
		comment_visual = "<leader>/",
		comment_line = "<leader>/",
	},
})
require("mini.operators").setup({
	replace = {
		prefix = "<leader>p",
	},
})
