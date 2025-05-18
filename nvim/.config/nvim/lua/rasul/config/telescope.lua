local telescope = require("telescope")
local builtin   = require("telescope.builtin")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = "move_selection_previous",
        ["<C-j>"] = "move_selection_next",
      },
    },
  },
})

-- хоткеи из прежнего конфига
local map = vim.keymap.set
map("n", "<leader>pf", builtin.find_files, { desc = "Telescope: find files" })
map("n", "<C-p>",      builtin.git_files,  { desc = "Telescope: git files" })
map("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope: grep string" })

