require("rasul.config.rosepine")

-- функция с прозрачным фоном
local function ColorMyPencils()
  -- цветовая схема уже активирована rose-pine внутри rosepine.lua
  vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2E3440" })
end

local opaque_bg = vim.fn.exists("g:colors_name") == 1
                 and vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg")
                 or "#1b1d23"

vim.api.nvim_set_hl(0, "MasonNormal", { bg = opaque_bg })
vim.api.nvim_set_hl(0, "LazyNormal",  { bg = opaque_bg })

vim.api.nvim_set_hl(0, "MasonBorder", { bg = opaque_bg })
vim.api.nvim_set_hl(0, "LazyBorder",  { bg = opaque_bg })

ColorMyPencils()

