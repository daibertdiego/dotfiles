local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ChatGPT Main Interface
map("n", "<leader><leader>cc", "<cmd>ChatGPT<CR>", { desc = "ChatGPT", unpack(opts) })

-- Edit with Instruction
map("n", "<leader><leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction", unpack(opts) })
map("v", "<leader><leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", { desc = "Edit with instruction", unpack(opts) })

-- Grammar Correction
map("n", "<leader><leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction", unpack(opts) })
map("v", "<leader><leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", { desc = "Grammar Correction", unpack(opts) })

-- Translate
map("n", "<leader><leader>ct", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate", unpack(opts) })
map("v", "<leader><leader>ct", "<cmd>ChatGPTRun translate<CR>", { desc = "Translate", unpack(opts) })

-- Extract Keywords
map("n", "<leader><leader>ck", "<cmd>ChatGPTRun keywords<CR>", { desc = "Keywords", unpack(opts) })
map("v", "<leader><leader>ck", "<cmd>ChatGPTRun keywords<CR>", { desc = "Keywords", unpack(opts) })

-- Generate Docstring
map("n", "<leader><leader>cd", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring", unpack(opts) })
map("v", "<leader><leader>cd", "<cmd>ChatGPTRun docstring<CR>", { desc = "Docstring", unpack(opts) })

-- Add Tests
map("n", "<leader><leader>ca", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests", unpack(opts) })
map("v", "<leader><leader>ca", "<cmd>ChatGPTRun add_tests<CR>", { desc = "Add Tests", unpack(opts) })

-- Optimize Code
map("n", "<leader><leader>co", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code", unpack(opts) })
map("v", "<leader><leader>co", "<cmd>ChatGPTRun optimize_code<CR>", { desc = "Optimize Code", unpack(opts) })

-- Summarize Code
map("n", "<leader><leader>cs", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize", unpack(opts) })
map("v", "<leader><leader>cs", "<cmd>ChatGPTRun summarize<CR>", { desc = "Summarize", unpack(opts) })

-- Fix Bugs
map("n", "<leader><leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", { desc = "Fix Bugs", unpack(opts) })
map("v", "<leader><leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", { desc = "Fix Bugs", unpack(opts) })

-- Explain Code
map("n", "<leader><leader>cx", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code", unpack(opts) })
map("v", "<leader><leader>cx", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Code", unpack(opts) })

-- Code Readability Analysis
map(
	"n",
	"<leader><leader>cr",
	"<cmd>ChatGPTRun code_readability_analysis<CR>",
	{ desc = "Code Readability Analysis", unpack(opts) }
)
map(
	"v",
	"<leader><leader>cr",
	"<cmd>ChatGPTRun code_readability_analysis<CR>",
	{ desc = "Code Readability Analysis", unpack(opts) }
)

-- Roxygen Edit
map("n", "<leader><leader>cR", "<cmd>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen Edit", unpack(opts) })
map("v", "<leader><leader>cR", "<cmd>ChatGPTRun roxygen_edit<CR>", { desc = "Roxygen Edit", unpack(opts) })
