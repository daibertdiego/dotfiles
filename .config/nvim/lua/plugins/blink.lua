local blink = require("blink.cmp")
local icons = require("lib.icons")
blink.setup({
	-- 'default', 'super-tab', 'enter'
	keymap = {
		preset = "super-tab",

		cmdline = {
			preset = "enter",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},
	},
	-- 'preselect', 'manual', 'auto_insert'
	completion = {
		list = { selection = "auto_insert" },
		menu = { border = "rounded" },
		documentation = { window = { border = "rounded" } },
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
		default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot", "dadbod" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-cmp-copilot",
				score_offset = 90,
				async = true,
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
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
		},
	},
})