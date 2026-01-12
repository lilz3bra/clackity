local M = {}

local state = require("clackity.core.state")
M.load_keys = function(f)
  local keys = "abcdefghijklmnopqrstuvwxyz"
  for i = 1, #keys do
    local char = keys:sub(i, i)
    vim.keymap.set("n", char, function()
      M.move_cursor(f.win)
    end, { buffer = f.buf, nowait = true, noremap = true, silent = true })
  end
end

M.move_cursor = function(win)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row = cursor[1]
  local col = cursor[2]

  -- Check the lenght of the line here for the time being, should be a better place to do this?
  -- This just updates the state on the first run.
  if col == 0 and row == 1 then
    local line = vim.api.nvim_get_current_line()
    state.line_lenght = vim.fn.strchars(line) - 1
  end

  col = col + 1
  if col > state.line_lenght then
    col = 0
    row = row + 1
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)
    local next_line_text = line[1]
    state.line_lenght = vim.fn.strchars(next_line_text) - 1
  end

  state.current_row = row
  state.current_col = col
  vim.api.nvim_win_set_cursor(win, { row, col })
end
return M
