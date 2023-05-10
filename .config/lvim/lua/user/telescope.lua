local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fG', builtin.git_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

lvim.builtin.which_key.mappings['f'] = {}
lvim.builtin.which_key.mappings["f"].name = "Telescope"
lvim.builtin.which_key.mappings["ff"] = { builtin.find_files, "Find files" }
lvim.builtin.which_key.mappings["fG"] = { builtin.git_files, "Find Git Files" }
lvim.builtin.which_key.mappings["fg"] = { builtin.live_grep, "Find Text" }
lvim.builtin.which_key.mappings["fh"] = { builtin.help_tags, "Find help" }

lvim.builtin.telescope.defaults.file_ignore_patterns = {
  "vendor/*",
  "%.lock",
  "__pycache__/*",
  "%.sqlite3",
  "%.ipynb",
  "node_modules/*",
  ".m2/*",
  "%.jpg",
  "%.jpeg",
  "%.png",
  "%.svg",
  "%.otf",
  "%.ttf",
  ".git/",
  "%.webp",
  ".dart_tool/",
  ".github/",
  ".gradle/",
  ".idea/",
  ".settings/",
  ".vscode/",
  "__pycache__/",
  "build/",
  "env/",
  "gradle/",
  "node_modules/",
  "target/",
  "%.pdb",
  "%.dll",
  "%.class",
  "%.exe",
  "%.cache",
  "%.ico",
  "%.pdf",
  "%.dylib",
  "%.jar",
  "%.docx",
  "%.met",
  "smalljre_*/*",
  ".vale/",
  "%.burp",
  "%.mp4",
  "%.mkv",
  "%.rar",
  "%.zip",
  "%.7z",
  "%.tar",
  "%.bz2",
  "%.epub",
  "%.flac",
  "%.tar.gz",
}
