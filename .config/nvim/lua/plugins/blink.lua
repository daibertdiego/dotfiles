local blink = require("blink.cmp")
local icons = require("lib.icons")
-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ";"

blink.setup({
	-- 'default', 'super-tab', 'enter'
	keymap = {
		preset = "enter",
		["<CR>"] = { "select_and_accept", "fallback" },
		["<S-k>"] = { "scroll_documentation_up", "fallback" },
		["<S-j>"] = { "scroll_documentation_down", "fallback" },

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },

		cmdline = {
			preset = "enter",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},
	},
	-- 'preselect', 'manual', 'auto_insert'
	completion = {
		-- list = { selection = {auto_insert = true }},
		list = { selection = {
			preselect = function(ctx)
				return ctx.mode ~= "cmdline"
			end,
		} },
		menu = { border = "rounded" },
		documentation = {
			auto_show = true,
			window = {
				border = "rounded",
			},
		},
		-- Displays a preview of the selected item on the current line
		ghost_text = {
			enabled = true,
		},
	},
	snippets = {
		preset = "luasnip",
		-- This comes from the luasnip extra, if you don't add it, won't be able to
		-- jump forward or backward in luasnip snippets
		-- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
		active = function(filter)
			if filter and filter.direction then
				return require("luasnip").jumpable(filter.direction)
			end
			return require("luasnip").in_snippet()
		end,
		jump = function(direction)
			require("luasnip").jump(direction)
		end,
	},
	signature = { window = { border = "rounded" } },
	appearance = {
		-- Sets the fallback highlight groups to nvim-cmp's highlight groups
		use_nvim_cmp_as_default = true,
		-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		nerd_font_variant = "normal",
		kind_icons = icons.kind,
	},
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot", "dadbod", "emoji" },
		providers = {
			lsp = {
				name = "lsp",
				enabled = true,
				module = "blink.cmp.sources.lsp",
				-- kind = "LSP",
				-- When linking markdown notes, I would get snippets and text in the
				-- suggestions, I want those to show only if there are no LSP
				-- suggestions
				-- Disabling fallbacks as my snippets wouldn't show up
				-- Enabled fallbacks as this seems to be working now
				fallbacks = { "snippets", "buffer" },
				score_offset = 90, -- the higher the number, the higher the priority
			},
			path = {
				name = "Path",
				module = "blink.cmp.sources.path",
				score_offset = 25,
				-- When typing a path, I would get snippets and text in the
				-- suggestions, I want those to show only if there are no path
				-- suggestions
				fallbacks = { "snippets", "buffer" },
				opts = {
					trailing_slash = false,
					label_trailing_slash = true,
					get_cwd = function(context)
						return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
					end,
					show_hidden_files_by_default = true,
				},
			},
			buffer = {
				name = "Buffer",
				enabled = true,
				max_items = 5,
				module = "blink.cmp.sources.buffer",
				min_keyword_length = 4,
				score_offset = 15, -- the higher the number, the higher the priority
			},
			copilot = {
				name = "copilot",
				module = "blink-cmp-copilot",
				score_offset = 100,
				async = true,
				min_keyword_length = 6,
				transform_items = function(_, items)
					local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					local kind_idx = #CompletionItemKind + 1
					CompletionItemKind[kind_idx] = "Copilot"
					for _, item in ipairs(items) do
						item.kind = kind_idx
					end
					return items
				end,
			},
			snippets = {
				name = "snippets",
				enabled = true,
				max_items = 8,
				min_keyword_length = 2,
				module = "blink.cmp.sources.snippets",
				score_offset = 85, -- the higher the number, the higher the priority
				-- Only show snippets if I type the trigger_text characters, so
				-- to expand the "bash" snippet, if the trigger_text is ";" I have to
				should_show_items = function()
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
					-- NOTE: remember that `trigger_text` is modified at the top of the file
					return before_cursor:match(trigger_text .. "%w*$") ~= nil
				end,
				-- After accepting the completion, delete the trigger_text characters
				-- from the final inserted text
				transform_items = function(_, items)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
					local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
					if trigger_pos then
						for _, item in ipairs(items) do
							item.textEdit = {
								newText = item.insertText or item.label,
								range = {
									start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
									["end"] = { line = vim.fn.line(".") - 1, character = col },
								},
							}
						end
					end
					-- NOTE: After the transformation, I have to reload the luasnip source
					-- Otherwise really crazy shit happens and I spent way too much time
					-- figurig this out
					vim.schedule(function()
						require("blink.cmp").reload("snippets")
					end)
					return items
				end,
			},
			-- Example on how to configure dadbod found in the main repo
			-- https://github.com/kristijanhusak/vim-dadbod-completion
			dadbod = {
				name = "Dadbod",
				module = "vim_dadbod_completion.blink",
				score_offset = 85, -- the higher the number, the higher the priority
			},
			-- https://github.com/moyiz/blink-emoji.nvim
			-- Triggered by ':'
			emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 15, -- the higher the number, the higher the priority
				opts = { insert = true }, -- Insert emoji (default) or complete its name
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
		-- command line completion, thanks to dpetka2001 in reddit
		-- https://www.reddit.com/r/neovim/comments/1hjjf21/comment/m37fe4d/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
		cmdline = function()
			local type = vim.fn.getcmdtype()
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			if type == ":" then
				return { "cmdline" }
			end
			return {}
		end,
	},
})

-- Hide Copilot on suggestion
vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuOpen",
	callback = function()
		require("copilot.suggestion").dismiss()
		vim.b.copilot_suggestion_hidden = true
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuClose",
	callback = function()
		vim.b.copilot_suggestion_hidden = false
	end,
})
