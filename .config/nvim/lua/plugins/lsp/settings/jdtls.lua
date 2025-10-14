-- Centralized JDTLS configuration
-- Java 21 is used for: JDTLS server and formatter
-- Project Java version is detected dynamically per project

local M = {}

-- Fixed Java 21 for JDTLS server and formatter
M.JDTLS_JAVA_HOME = vim.fn.expand("~/.sdkman/candidates/java/21.0.2-graalce")
M.JDTLS_JAVA_BIN = M.JDTLS_JAVA_HOME .. "/bin/java"

-- Helper functions
local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.detect_project_java()
	-- Check JAVA_HOME first
	if vim.env.JAVA_HOME and #vim.env.JAVA_HOME > 0 then
		return trim(vim.env.JAVA_HOME)
	end

	-- Parse from java command
	local lines = vim.fn.systemlist("java -XshowSettings:properties -version 2>&1")
	for _, line in ipairs(lines) do
		local path = line:match("^%s*java%.home%s*=%s*(.+)$")
		if path then
			return trim(path)
		end
	end

	-- Fallback to Java 21
	return M.JDTLS_JAVA_HOME
end

function M.detect_java_version(java_home)
	local cmd = string.format("%s/bin/java -version 2>&1", java_home)
	local out = table.concat(vim.fn.systemlist(cmd), "\n")
	local ver = out:match('version%s+"(%d+)[%._]') or out:match("openjdk%s+(%d+)[%._]")
	return ver and tonumber(ver) or 21
end

function M.get_runtimes()
	local project_java = M.detect_project_java()
	local project_version = M.detect_java_version(project_java)

	local runtimes = {
		{ name = "JavaSE-21", path = M.JDTLS_JAVA_HOME, default = true },
	}

	-- Add project Java if different from Java 21
	if project_java ~= M.JDTLS_JAVA_HOME then
		table.insert(runtimes, {
			name = string.format("JavaSE-%d", project_version),
			path = vim.fn.fnamemodify(project_java, ":p"),
		})
	end

	return runtimes
end

-- Settings that will be merged with defaults
M.settings = {
	java = {
		configuration = {
			runtimes = M.get_runtimes(),
			updateBuildConfiguration = "interactive",
		},
		import = {
			maven = { enabled = true },
			gradle = { enabled = true },
		},
		maven = { downloadSources = true },
		eclipse = { downloadSources = true },
		format = {
			enabled = true,
			settings = {
				url = vim.fn.stdpath("data") .. "/mason/packages/google-java-format/google-java-format.jar",
				profile = "Google",
			},
		},
		inlayHints = {
			parameterNames = { enabled = "all" },
		},
		completion = {
			favoriteStaticMembers = {
				"org.junit.jupiter.api.Assertions.*",
				"org.junit.Assert.*",
				"org.mockito.Mockito.*",
			},
			filteredTypes = {
				"com.sun.*",
				"io.micrometer.shaded.*",
				"java.awt.*",
				"jdk.*",
				"sun.*",
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},
}

return M
