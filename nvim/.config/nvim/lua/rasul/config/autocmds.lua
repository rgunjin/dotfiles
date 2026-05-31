vim.o.guicursor = "n-v-c:block,i-ci:ver25,r-cr:hor20,o:hor50"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
