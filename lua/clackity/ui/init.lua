local M = {}

local create_window = function(opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns / 2)
  local height = math.floor((vim.o.lines - 4) / 2)

  local col = (vim.o.columns - width) / 2
  local row = (vim.o.lines - height) / 2

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    col = col,
    row = row,
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end
local core = require("clackity.core")
M.start_window = function()
  local float = create_window()
  local words = core.get_words(2)
  local bufnr = float.buf

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, words)

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(float.win, true)
  end, { silent = true, buffer = bufnr })
end

return M
