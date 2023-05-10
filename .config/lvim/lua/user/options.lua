lvim.builtin.alpha.dashboard.section.header.val = require("user.banners").dashboard()
lvim.transparent_window = true -- enable/disable transparency
-- vim.lsp.set_log_level "error"
lvim.log.level = "warn"
vim.opt.relativenumber = true --relative line numbers
vim.opt.wrap = true           --wrap lines
lvim.format_on_save = true
vim.opt.spell = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"
