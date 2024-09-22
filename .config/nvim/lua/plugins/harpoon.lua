local harpoon = require("harpoon")

harpoon:setup({})

vim.keymap.set("n", "<leader>m", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(4) end)

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>sh", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

-- lvim.keys.normal_mode["<leader>a"]= mark.add_file
-- lvim.keys.normal_mode["<leader>h"]= ui.toggle_quick_menu
-- lvim.keys.normal_mode["<leader>1"]= function() ui.nav_file(1) end
-- lvim.keys.normal_mode["<leader>2"]= function() ui.nav_file(2) end
-- lvim.keys.normal_mode["<leader>3"]= function() ui.nav_file(3) end
-- lvim.keys.normal_mode["<leader>4"]= function() ui.nav_file(4) end


-- lvim.builtin.which_key.mappings["1"] = { function() ui.nav_file(1) end, "Go To Mark 1" }
-- lvim.builtin.which_key.mappings["2"] = { function() ui.nav_file(2) end, "Go To Mark 2" }
-- lvim.builtin.which_key.mappings["3"] = { function() ui.nav_file(3) end, "Go To Mark 3" }
-- lvim.builtin.which_key.mappings["4"] = { function() ui.nav_file(4) end, "Go To Mark 4" }
-- lvim.builtin.which_key.mappings["a"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", " Add Mark" }
-- lvim.builtin.which_key.mappings["h"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", " Harpoon" }
