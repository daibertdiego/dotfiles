-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	-- Comment after installation since this slowdown the initialization of neovim
	-- ensure_installed = {
	-- 	"go",
	-- 	"java",
	-- 	"lua",
	-- 	"python",
	-- 	"rust",
	-- 	"typescript",
	-- 	"regex",
	-- 	"bash",
	-- 	"markdown",
	-- 	"markdown_inline",
	-- 	"kdl",
	-- 	"sql",
	-- 	"org",
	-- 	"terraform",
	-- 	"html",
	-- 	"css",
	-- 	"javascript",
	-- 	"yaml",
	-- 	"json",
	-- 	"toml",
	-- 	"kotlin",
	-- },

	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
	-- Trying to improve startup time and using mini.ai for extra navigation options.
	-- textobjects = {
	-- 	select = {
	-- 		enable = true,
	-- 		lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
	-- 		keymaps = {
	-- 			-- You can use the capture groups defined in textobjects.scm
	-- 			["aa"] = "@parameter.outer",
	-- 			["ia"] = "@parameter.inner",
	-- 			["af"] = "@function.outer",
	-- 			["if"] = "@function.inner",
	-- 			["ac"] = "@class.outer",
	-- 			["ic"] = "@class.inner",
	-- 			["ii"] = "@conditional.inner",
	-- 			["ai"] = "@conditional.outer",
	-- 			["il"] = "@loop.inner",
	-- 			["al"] = "@loop.outer",
	-- 			["at"] = "@comment.outer",
	-- 		},
	-- 	},
	-- 	move = {
	-- 		enable = true,
	-- 		set_jumps = true, -- whether to set jumps in the jumplist
	-- 		goto_next_start = {
	-- 			["]f"] = "@function.outer",
	-- 			["]]"] = "@class.outer",
	-- 		},
	-- 		goto_next_end = {
	-- 			["]F"] = "@function.outer",
	-- 			["]["] = "@class.outer",
	-- 		},
	-- 		goto_previous_start = {
	-- 			["[f"] = "@function.outer",
	-- 			["[["] = "@class.outer",
	-- 		},
	-- 		goto_previous_end = {
	-- 			["[F"] = "@function.outer",
	-- 			["[]"] = "@class.outer",
	-- 		},
	-- 		goto_next = {
	-- 			["]i"] = "@conditional.inner",
	-- 			["]a"] = "@parameter.outer",
	-- 		},
	-- 		goto_previous = {
	-- 			["[i"] = "@conditional.inner",
	-- 			["[a"] = "@parameter.outer",
	-- 		},
	-- 	},
	-- swap = {
	-- 	enable = true,
	-- 	-- It was conflicting with Hurl keymaps
	-- 	-- swap_next = {
	-- 	-- 	["<leader>a"] = "@parameter.inner",
	-- 	-- },
	-- 	-- swap_previous = {
	-- 	-- 	["<leader>A"] = "@parameter.inner",
	-- 	-- },
	-- },
	-- },
})
