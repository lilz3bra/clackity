local M = {}

local state = require("clackity.core.state")
M.load_keys = function(f)
  local keys = "abcdefghijklmnopqrstuvwxyz"
  for i = 1, #keys do
    local char = keys:sub(i, i)
    vim.keymap.set("n", char, function()
      M.move_cursor(f.win, char)
    end, { buffer = f.buf, nowait = true, noremap = true, silent = true })
  end
end

M.move_cursor = function(win, key)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row = cursor[1]
  local col = cursor[2]

  local line = vim.api.nvim_get_current_line()
  -- This just updates the state on the first run.
  if col == 0 and row == 1 then
    state.line_lenght = vim.fn.strchars(line) - 1
  end

  local char = line:sub(col + 1, col + 1)
  if key ~= char then
    return
  end
  col = col + 1
  if col > state.line_lenght then
    col = 0
    row = row + 1
    line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
    local next_line_text = line[1]
    state.line_lenght = vim.fn.strchars(next_line_text) - 1
  end

  state.current_row = row
  state.current_col = col
  vim.api.nvim_win_set_cursor(win, { row, col })
end

return M
