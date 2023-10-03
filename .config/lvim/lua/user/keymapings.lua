lvim.leader = "space"

local opts = { noremap = true, silent = true }
-- For the description on keymaps, I have a function getOptions(desc) which returns noremap=true, silent=true and desc=desc. Then call: keymap(mode, keymap, command, getOptions("some randome desc")

local keymap = vim.keymap.set

-- Used by Harpoon
lvim.builtin.which_key.mappings["h"] = {}

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)


keymap("n", "<C-Space>", "<cmd>WhichKey \\<space><cr>", opts)
keymap("n", "<C-i>", "<C-i>", opts)


-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- greatest remap ever
vim.keymap.set("x", "p", [["_dP]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

keymap("n", "<CR>", ":noh<CR><CR>", opts)

keymap("n", "Q", "<cmd>bdelete!<CR>", opts)

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [[:%y+<CR>]])
vim.keymap.set("v", "<leader>Y", [["y+]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])


-- Check if we are inside tmux
if vim.fn.exists('$TMUX') == 1 then
  --  Remap C-a to be typed twice when inside tmux
  keymap('n', '<C-a>', '<C-a><C-a>', opts)
else
  -- Use the default behavior of C-a outside tmux
  keymap('n', '<C-a>', '<C-a>', opts)
end
