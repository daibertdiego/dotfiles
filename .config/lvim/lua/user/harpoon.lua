local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- lvim.keys.normal_mode["<leader>a"]= mark.add_file
-- lvim.keys.normal_mode["<leader>h"]= ui.toggle_quick_menu
-- lvim.keys.normal_mode["<leader>1"]= function() ui.nav_file(1) end
-- lvim.keys.normal_mode["<leader>2"]= function() ui.nav_file(2) end
-- lvim.keys.normal_mode["<leader>3"]= function() ui.nav_file(3) end
-- lvim.keys.normal_mode["<leader>4"]= function() ui.nav_file(4) end


lvim.builtin.which_key.mappings["1"] = { function() ui.nav_file(1) end, "Go To Mark 1" }
lvim.builtin.which_key.mappings["2"] = { function() ui.nav_file(2) end, "Go To Mark 2" }
lvim.builtin.which_key.mappings["3"] = { function() ui.nav_file(3) end, "Go To Mark 3" }
lvim.builtin.which_key.mappings["4"] = { function() ui.nav_file(4) end, "Go To Mark 4" }
lvim.builtin.which_key.mappings["a"] = { "<cmd>lua require('harpoon.mark').add_file()<CR>", " Add Mark" }
lvim.builtin.which_key.mappings["h"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", " Harpoon" }
