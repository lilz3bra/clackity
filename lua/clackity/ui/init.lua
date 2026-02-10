local M = {}

local window = require("clackity.ui.window")
local highlight = require("clackity.ui.highlight")

function M.create_window()
  highlight.setup()

  local obj = window.create_window()

  vim.api.nvim_set_option_value("buftype", "nofile", { buf = obj.buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = obj.buf })

  window.buffer_keys_fix(obj.buf)
  window.set_fake_cursor()
  vim.api.nvim_set_option_value("virtualedit", "all", { scope = "local", win = obj.win })

  return obj
end

function M.render_main(buf, lines)
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  highlight.clear(buf)
end

function M.render_lines(buf, words)
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, words)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

  highlight.clear(buf)

  for i, line in ipairs(words) do
    highlight.paint(buf, "ClackityFuture", i - 1, 0, #line)
  end
end

function M.mark_correct(buf, row, col)
  highlight.paint(buf, "ClackityCorrect", row, col, col + 1)
end

function M.mark_error(buf, row, col)
  highlight.paint(buf, "ClackityError", row, col, col + 1)
end

function M.move_cursor(win, row, col)
  pcall(vim.api.nvim_win_set_cursor, win, { row + 1, col })
end

return M
