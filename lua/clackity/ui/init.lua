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

function M.draw_menu(bufnr)
  M.render_main(bufnr, {
    "",
    "   CLACKITY TYPE   ",
    "   -------------   ",
    "",
    " [Enter] Start Lesson",
    " [s]     Stats       ",
    " [q]     Quit        "
  })
end

function M.draw_post_lesson(bufnr, stats)
  local stats_text = {
    "",
    "  LESSON COMPLETE  ",
    "",
    "   Keys:    " .. stats.total_chars,
    "   Errors:  " .. stats.errors,
    "   WPM:     " .. stats.wpm,
    string.format("   Time:    %.1f seconds", stats.time / 1000),
    "   Acc:     " .. stats.accuracy .. " %",
    "   Consist: " .. stats.consistency .. " %",
    "",
    " [r] Retry  [m] Menu [q] Quit"
  }
  M.render_main(bufnr, stats_text)
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

function M.close(win_id)
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
  window.restore_cursor()
end

function M.get_content_width(win_id)
  return vim.api.nvim_win_get_width(win_id) - 4
end

return M
