-- require('telescope').load_extension('harpoon')
require("telescope").load_extension("git_worktree")
local actions = require("telescope.actions")

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.65,
				size = {
					width = "95%",
					height = "95%",
				},
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown", -- Use dropdown theme for this picker
			},
		},
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<CR>"] = actions.select_default,
				["<C-CR>"] = function(prompt_bufnr)
					local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
					local selections = picker:get_multi_selection()
					if #selections == 0 then
						actions.select_default(prompt_bufnr)
					else
						for _, entry in ipairs(selections) do
							vim.cmd("badd " .. vim.fn.fnameescape(entry.filename or entry.value))
						end
						actions.close(prompt_bufnr)
						vim.cmd("buffer " .. vim.fn.fnameescape(selections[1].filename or selections[1].value))
					end
				end,
			},
			n = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<CR>"] = actions.select_default,
				["<C-CR>"] = function(prompt_bufnr)
					local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
					local selections = picker:get_multi_selection()
					if #selections == 0 then
						actions.select_default(prompt_bufnr)
					else
						for _, entry in ipairs(selections) do
							vim.cmd("badd " .. vim.fn.fnameescape(entry.filename or entry.value))
						end
						actions.close(prompt_bufnr)
						vim.cmd("buffer " .. vim.fn.fnameescape(selections[1].filename or selections[1].value))
					end
				end,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>s/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10, -- Adjust transparency
		previewer = false, -- Disable preview for dropdown theme
		layout_config = {
			width = 0.5, -- Adjust width
			height = 0.5, -- Adjust height
		},
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sc", function()
	require("telescope.builtin").find_files({
		prompt_title = "[S]earch .[C]onfig Files",
		cwd = vim.fn.expand("~/.config"),
		hidden = true, -- Include hidden files
	})
end, { desc = "[ ] Find files in .config" })
vim.keymap.set("n", "<leader>sS", require("telescope.builtin").git_status, { desc = "[S]earch Git [S]tatus" })
vim.keymap.set("n", "<leader>sm", ":Telescope harpoon marks<CR>", { desc = "Harpoon [M]arks" })
vim.keymap.set("n", "<Leader>sr", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
vim.keymap.set(
	"n",
	"<Leader>sR",
	"<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
	silent
)
vim.keymap.set("n", "<Leader>sn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", silent)
vim.keymap.set("n", "<Leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })

vim.api.nvim_set_keymap("n", "<leader>st", ":TodoTelescope<CR>", { noremap = true })
vim.api.nvim_set_keymap(
	"n",
	"<Leader><tab>",
	"<Cmd>lua require('telescope.builtin').commands()<CR>",
	{ noremap = false }
)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "xml", "yaml" },
	callback = function()
		vim.keymap.set("n", "<leader>j", "<cmd>Telescope jsonfly<cr>", {
			desc = "Open json(fly)",
			buffer = true, -- Only for the current buffer
		})
	end,
})
