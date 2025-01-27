-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and stay" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and stay" })

-- greatest remap ever
vim.keymap.set("x", "p", [["_dP]], { noremap = true, desc = "Paste without replacing register" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, desc = "Exit insert mode" })
vim.keymap.set("n", "<C-c>", "<Esc>", { noremap = true, desc = "Exit insert mode" })

-- Buffers
vim.keymap.set("n", "<leader>bk", ":blast<CR>", { noremap = true, silent = true, desc = "Go to the last buffer" })
vim.keymap.set("n", "<leader>bj", ":bfirst<CR>", { noremap = true, silent = true, desc = "Go to the first buffer" })
vim.keymap.set("n", "<leader>bb", ":bprev<CR>", { noremap = true, silent = true, desc = "Go to the previous buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Go to the next buffer" })
vim.keymap.set(
	"n",
	"<leader>bd",
	":bdelete!<CR>",
	{ noremap = true, silent = true, desc = "Delete the current buffer" }
)
vim.keymap.set(
	"n",
	"<leader>bc",
	":bdelete!<CR>",
	{ noremap = true, silent = true, desc = "Delete the current buffer" }
)
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete the current buffer" })

vim.keymap.set("n", "<leader>q", function()
	local quickfix_open = vim.fn.getqflist({ winid = 0 }).winid ~= 0
	if quickfix_open then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, { noremap = true, silent = true, desc = "Toggle Quickfix List" })

vim.keymap.set(
	"n",
	"<leader>bx",
	"<C-w>o",
	{ noremap = true, silent = true, desc = "Close all windows except the current one" }
)

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Files
vim.keymap.set("n", "QQ", ":q!<CR>", { noremap = true, silent = true, desc = "Quit without saving" })
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { noremap = true, silent = true, desc = "Save file" })
vim.keymap.set("n", "TT", ":TransparentToggle<CR>", { noremap = true, desc = "Toggle transparency" })
vim.keymap.set("n", "<CR>", ":noh<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- Splits
vim.keymap.set("n", "<C-W>,", ":vertical resize -10<CR>", { noremap = true, desc = "Decrease vertical window size" })
vim.keymap.set("n", "<C-W>.", ":vertical resize +10<CR>", { noremap = true, desc = "Increase vertical window size" })

-- Moving block codes around
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "K", ":m '<-3<CR>gv=gv", { noremap = true, silent = true, desc = "Move block up" })

-- Navigation
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and restore cursor" })
-- Disabling this for mini.animate conflicts
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
-- vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true, desc = "Next search and center" })
-- vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true, desc = "Previous search and center" })
-- vim.keymap.set("n", "*", "*zz", { noremap = true, silent = true, desc = "Next occurrence and center" })
-- vim.keymap.set("n", "#", "#zz", { noremap = true, silent = true, desc = "Previous occurrence and center" })
-- vim.keymap.set("n", "g*", "g*zz", { noremap = true, silent = true, desc = "Next partial match and center" })
-- vim.keymap.set("n", "g#", "g#zz", { noremap = true, silent = true, desc = "Previous partial match and center" })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Disable space key" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up with wrap handling" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down with wrap handling" })

-- -- Noice
-- vim.keymap.set(
-- 	"n",
-- 	"<space><space>",
-- 	":Noice dismiss<CR>",
-- 	{ noremap = true, silent = true, desc = "Dismiss Noice notifications" }
-- )

-- Search and replace
vim.keymap.set(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ noremap = true, desc = "Search and replace word under cursor" }
)

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Yanking
vim.keymap.set("n", "<leader>y", [[:%y+<CR>]], { noremap = true, desc = "Yank entire file to clipboard" })
vim.keymap.set("v", "<leader>y", [["y+]], { noremap = true, desc = "Yank selection to clipboard" })

-- Deleting
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { noremap = true, desc = "Delete without copying to register" })

-- ThePrimeagen quick fix navigation from outside the quick fix buffer.
-- this consumes tow global keymaps as the trade-off
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Jump to the next item in the quickfix list" })
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Jump to the previous item in the quickfix list" })

vim.keymap.set("n", "<leader>v", "ggVG", { noremap = true, desc = "Visually select entire buffer" })

vim.keymap.set("n", "z=", function()
	local word = vim.fn.expand("<cword>")
	local suggestions = vim.fn.spellsuggest(word)

	-- Create a new list with formatted suggestions
	local formatted_suggestions = {}
	for i, suggestion in ipairs(suggestions) do
		table.insert(formatted_suggestions, string.format("%d -> %s", i, suggestion))
	end

	vim.ui.select(
		formatted_suggestions,
		{},
		vim.schedule_wrap(function(selected)
			if selected then
				-- Extract the actual suggestion from the selected string
				local index = tonumber(selected:match("^(%d+)")) -- Get the number at the start
				local actual_suggestion = suggestions[index] -- Get the corresponding suggestion
				vim.api.nvim_feedkeys("ciw" .. actual_suggestion, "n", true)
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
			end
		end)
	)
end)

local function toggle_float_term()
	local term_id = vim.api.nvim_get_current_buf()
	-- Check if the terminal is already open
	if vim.bo.filetype == "toggleterm" then
		vim.cmd("ToggleTermToggleAll") -- Hide the terminal if it's open
	else
		vim.cmd("ToggleTerm direction=float") -- Open the floating terminal if not open
	end
end

-- Keymap for toggling the floating terminal
vim.keymap.set(
	{ "n", "t" }, -- Apply in both normal and terminal modes
	"<C-\\>",
	toggle_float_term,
	{ noremap = true, silent = true, desc = "Toggle floating terminal" }
)

-- Open Neovim config
vim.keymap.set("n", "<leader>nc", function()
	vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit Neovim config" })

-- Reload Neovim config
vim.keymap.set("n", "<leader>nr", function()
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
	print("Config reloaded!")
end, { desc = "Source Neovim config" })

-- Open plugin configuration
vim.keymap.set("n", "<leader>np", function()
	vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/plugins/lazy.lua")
end, { desc = "Edit plugins config" })
