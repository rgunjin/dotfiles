require("gitsigns").setup({
  signs = {
    add          = { text = "+" },    -- добавленные строки
    change       = { text = "~" },    -- изменённые строки
    delete       = { text = "_" },    -- удалённые строки (нижнее подчёркивание)
    topdelete    = { text = "‾" },    -- удалённые сверху
    changedelete = { text = "~" },    -- изменённые и удалённые
  },
  -- Показывать статус в строке и боковой колонке
  numhl = false,
  linehl = false,
  word_diff = false,

  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  current_line_blame = false,
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- использовать стандартный форматтер
})

