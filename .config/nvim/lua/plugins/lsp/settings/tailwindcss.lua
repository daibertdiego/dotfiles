return {
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	init_options = {
		userLanguages = {
			javascript = "javascript",
			javascriptreact = "javascriptreact",
			typescript = "typescript",
			typescriptreact = "typescriptreact",
		},
	},
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
					{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					"className\\s*[:=]\\s*['\"`]([^'\"`]*)['\"`]",
				},
			},
		},
	},
}
