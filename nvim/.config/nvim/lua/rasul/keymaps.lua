local map = vim.keymap.set

vim.g.mapleader = " "

map("n", "<leader>pv", vim.cmd.Ex)

-- copy/past in system buffer
map({"n", "v"}, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", 'gg"+yG', { desc = "Yank whole buffer to system clipboard" })
map({"n", "v"}, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({"n", "v"}, "<leader>P", '"+P', { desc = "Paste before cursor from system clipboard" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- greatest remap ever
map("x", "<leader>gp", [["_dP]])

map({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
map("i", "<C-c>", "<Esc>")

-- G-spot entry
map("n", "<C-g>", function()
    vim.fn.jobstart({"tmux", "neww", "tmux-sessionizer"})
end, { silent = true })

-- Format LSP
map("n", "<leader>f", vim.lsp.buf.format)

-- Запуск make
map("n", "<leader>m", ":make<CR>", { desc = "Run make" })

-- Quickfix 
map("n", "<leader>q", ":copen<CR>", { desc = "Open quickfix list" })
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep in project" })

-- Float_Warrning
map("n", "<leader>e", function()
    vim.diagnostic.open_float(nil, { focus = false })
end)
