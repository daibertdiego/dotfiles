local harpoon = require("harpoon")

harpoon:setup({})

vim.keymap.set("n", "<leader>m", function()
	harpoon:list():add()
end, {
	desc = "Add current file to Harpoon",
})

vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, {
	desc = "Toggle Harpoon quick menu",
})

vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, {
	desc = "Select Harpoon file 1",
})

vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, {
	desc = "Select Harpoon file 2",
})

vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(3)
end, {
	desc = "Select Harpoon file 3",
})

vim.keymap.set("n", "<leader>6", function()
	harpoon:list():select(4)
end, {
	desc = "Select Harpoon file 4",
})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

vim.keymap.set("n", "<leader>sh", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })
