local harpoon = require("harpoon")
harpoon:setup({
  settings = { save_on_toggle = true },
})

local list = harpoon:list()           -- список файлов

local map = vim.keymap.set
map("n", "<leader>a", function() list:add() end, { desc = "Harpoon add file" })
map("n", "<C-e>",     function() harpoon.ui:toggle_quick_menu(list) end,
                                             { desc = "Harpoon quick menu" })

-- навигация по файлам 1-4 (аналоги nav_file(N) из v1)
map("n", "<C-h>", function() list:select(1) end, { desc = "Harpoon file 1" })
map("n", "<C-n>", function() list:select(2) end, { desc = "Harpoon file 2" })
map("n", "<C-t>", function() list:select(3) end, { desc = "Harpoon file 3" })
map("n", "<C-f>", function() list:select(4) end, { desc = "Harpoon file 4" })

