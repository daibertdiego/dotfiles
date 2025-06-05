require("hurl").setup({
	ft = "hurl",
	-- Show debugging info
	debug = true,
	-- Show notification on run
	show_notification = false,
	-- Show response in popup or split
	mode = "popup",
	-- Default formatter
	formatters = {
		json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
		html = {
			"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
			"--parser",
			"html",
		},
		xml = {
			"tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
			"-xml",
			"-i",
			"-q",
		},
	},
	-- Default mappings for the response popup or split views
	mappings = {
		close = "q", -- Close the response popup or split view
		next_panel = "<C-n>", -- Move to the next response popup window
		prev_panel = "<C-p>", -- Move to the previous response popup window
	},

	-- file_root = ".",
})

-- Key mappings with vim.keymap.set
vim.keymap.set("n", "<leader>A", "<cmd>HurlRunner<CR>", { desc = "Run All requests" })
vim.keymap.set("n", "<leader>a", "<cmd>HurlRunnerAt<CR>", { desc = "Run API request" })
vim.keymap.set("n", "<leader>te", "<cmd>HurlRunnerToEntry<CR>", { desc = "Run API request to entry" })
vim.keymap.set("n", "<leader>tE", "<cmd>HurlRunnerToEnd<CR>", { desc = "Run API request from current entry to end" })
vim.keymap.set("n", "<leader>tm", "<cmd>HurlToggleMode<CR>", { desc = "Toggle Hurl Mode" })
vim.keymap.set("n", "<leader>tv", "<cmd>HurlVerbose<CR>", { desc = "Run API in verbose mode" })
vim.keymap.set("n", "<leader>tV", "<cmd>HurlVeryVerbose<CR>", { desc = "Run API in very verbose mode" })

-- For visual mode keymap
vim.keymap.set("v", "<leader>a", ":HurlRunner<CR>", { desc = "Hurl Runner" })
