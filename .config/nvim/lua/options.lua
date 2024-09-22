-- Set colorscheme
--vim.cmd [[colorscheme onedark]]
-- vim.cmd.colorscheme "catppuccin-frappe"

vim.opt.expandtab = true -- convert tabs to spces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab

-- Set highlight on search
vim.o.hlsearch = true

vim.opt.termguicolors = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

--wrap lines
vim.opt.wrap = true

-- Disable mouse mode
-- vim.o.mouse = ''

-- Enable break indent
vim.o.breakindent = true

-- Open new splits below the current buffer
vim.opt.splitbelow = true -- For horizontal splits
vim.opt.splitright = true -- For vertical splits

-- Save undo history
vim.o.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable speel check
vim.opt.spell = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Use faster scroll settings
-- vim.opt.lazyredraw = true

-- Improve file reading performance
vim.opt.ffs = "unix,dos"

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Concealer for Neorg
vim.o.conceallevel = 2

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Transparent Background
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Preview substitutions live, as you type!
-- vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Removes ~ by replacing it with a blank space
vim.opt.fillchars = { eob = " " }

-- lvim.transparent_window = true -- enable/disable transparency
-- -- vim.lsp.set_log_level "error"
-- lvim.log.level = "warn"
-- vim.opt.relativenumber = true --relative line numbers
-- vim.opt.wrap = true           --wrap lines
-- lvim.format_on_save = true
-- vim.opt.spell = true
--
--
-- vim.opt.updatetime = 50
