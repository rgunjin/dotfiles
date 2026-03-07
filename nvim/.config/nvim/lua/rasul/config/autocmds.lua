vim.o.guicursor = "n-v-c:block,i-ci:ver25,r-cr:hor20,o:hor50"

local function restore_terminal_cursor()
  vim.cmd("set guicursor=a:ver20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor")
end

vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  callback = restore_terminal_cursor,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

