-- Block lspconfig's jdtls BEFORE lspconfig loads (no require('lspconfig') here).

-- If anything tries to require lspconfig's jdtls config, return a proper stub.
local jdtls_stub = {
	setup = function(_) end,
	manager = { config = {} },
	name = "jdtls",
	cmd = function() return {} end,
}

package.preload["lspconfig.server_configurations.jdtls"] = function()
	return jdtls_stub
end
package.loaded["lspconfig.server_configurations.jdtls"] = jdtls_stub

-- Block the nvim-lspconfig LSP module for JDTLS
package.preload["lspconfig/lsp/jdtls"] = function()
	return jdtls_stub
end
package.loaded["lspconfig/lsp/jdtls"] = jdtls_stub

-- Some plugins do `require("lspconfig").jdtls.setup(...)`. Stub that entry too.
package.preload["lspconfig.jdtls"] = function()
	return jdtls_stub
end
package.loaded["lspconfig.jdtls"] = jdtls_stub
