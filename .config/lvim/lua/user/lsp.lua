vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "clangd",
  "dockerls",
  "gopls",
  "golangci_lint_ls",
  "jdtls",
  "pyright",
  "rust_analyzer",
  "taplo",
  "texlab",
  "tsserver",
  "yamlls",
  "emmet-ls",
})

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.emmet_ls.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.html.setup {}
