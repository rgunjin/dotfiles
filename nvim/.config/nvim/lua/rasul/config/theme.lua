require("rasul.config.rosepine")

-- функция с прозрачным фоном
local function ColorMyPencils()
  -- цветовая схема уже активирована rose-pine внутри rosepine.lua
  vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

