local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = { completeopt = "menu,menuone,noinsert" },
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" }, -- Autocomplete buffer words.
		{ name = "path" }, -- Autocompletes pahts.
		{ name = "calc" }, -- Autocompeltes math calculation.
		{ name = "vim-dadbod-completion" },
		{
			name = "spell",
			option = {
				keep_all_entries = false,
				enable_in_context = function()
					return true
				end,
				preselect_correct_word = true,
			},
		},
	},
	formatting = {
		format = function(entry, vim_item)
			-- Define custom icons for sources
			local custom_menu_icon = {
				calc = "󰃬 ",
			}

			-- Apply custom icon for 'calc' source
			if entry.source.name == "calc" then
				vim_item.kind = custom_menu_icon.calc
			end

			-- Define the menu display (optional)
			vim_item.menu = "    (" .. entry.source.name .. ") "
			return vim_item
		end,
	},
	-- Add the performance block here
	performance = {
		trigger_debounce_time = 500,
		throttle = 550,
		fetching_timeout = 80,
		max_view_entries = 10,
	},
})
