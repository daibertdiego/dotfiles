local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "CodeCompanionInline*",
	group = group,
	callback = function(request)
		if request.match == "CodeCompanionInlineFinished" then
			-- Format the buffer after the inline request has completed
			require("conform").format({ bufnr = request.buf })
		end
	end,
})

require("codecompanion").setup({
	strategies = {
		chat = {
			adapter = "anthropic",
			keymaps = {
				send = {
					modes = { n = "<C-Enter>", i = "<C-Enter>" },
				},
			},
		},
		inline = {
			adapter = "anthropic",
		},
	},
})

-- CodeCompanion Keybindings with Descriptions
-- Prefix: <leader><leader>C
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- Actions
map("n", "<leader><leader>Ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions", unpack(opts) })
map("v", "<leader><leader>Ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions", unpack(opts) })

-- Chat Toggle
map(
	"n",
	"<leader><leader>CC",
	"<cmd>CodeCompanionChat Toggle<cr>",
	{ desc = "CodeCompanion Chat Toggle", unpack(opts) }
)
map(
	"v",
	"<leader><leader>CC",
	"<cmd>CodeCompanionChat Toggle<cr>",
	{ desc = "CodeCompanion Chat Toggle", unpack(opts) }
)

-- Add to Chat
map("v", "<leader><leader>CA", "<cmd>CodeCompanionChat Add<cr>", { desc = "CodeCompanion Chat Add", unpack(opts) })

-- Expand 'cc' into 'CodeCompanion' in command line
vim.cmd([[cab cc CodeCompanion]])
