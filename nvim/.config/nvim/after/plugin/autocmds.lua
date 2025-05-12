vim.api.nvim_create_autocmd(
    { "VimLeave" },
    { command = "set guicursor=a:ver20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor" }
)
