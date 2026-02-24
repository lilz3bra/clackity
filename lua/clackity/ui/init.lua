local M = {}

local window = require("clackity.ui.window")
local highlight = require("clackity.ui.highlight")
local menu_group = vim.api.nvim_create_augroup("ClackityMenu", { clear = true })
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
    "   CLACKITY ",
    "   -------------   ",
    "",
    " [Enter] Start Lesson",
    " [o]     Options",
    " [q]     Quit        "
  })
end

--- @param bufnr number
--- @param title string
--- @param opts string[]
function M.draw_selector(bufnr, win_id, title, opts)
  local lines = {
    "",
    "   " .. title,
    "   " .. string.rep("-", #title),
    ""
  }

  local header_offset = #lines

  for _, opt in ipairs(opts) do
    table.insert(lines, "   " .. opt)
  end

  table.insert(lines, "")
  table.insert(lines, " [Enter] Select  [Esc/q] Back")

  M.render_main(bufnr, lines)

  pcall(vim.api.nvim_win_set_cursor, win_id, { header_offset + 1, 0 })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    group = menu_group,
    callback = function()
      local row = vim.api.nvim_win_get_cursor(0)[1]

      highlight.clear(bufnr)

      if row > header_offset and row <= header_offset + #opts then
        highlight.paint_line(bufnr, "ClackitySelection", row - 1)
      end
    end
  })
end

function M.draw_post_lesson(bufnr, stats)
  local stats_text = {
    "",
    "  LESSON COMPLETE  ",
    "",
    string.format("   Keys:   %d", stats.total_chars),
    string.format("   Errors:  %d", stats.errors),
    string.format("   WPM:     %.1f", stats.wpm),
    string.format("   Time:    %.1f seconds", stats.time / 1000),
    string.format("   Acc:     %.2f %%", stats.accuracy),
    string.format("   Consist: %.2f %%", stats.consistency),
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

function M.mark_correct(buf, row, col_start, col_end)
  highlight.paint(buf, "ClackityCorrect", row, col_start, col_end)
end

function M.mark_error(buf, row, col_start, col_end)
  highlight.paint(buf, "ClackityError", row, col_start, col_end)
end

function M.move_cursor(win, row, col)
  vim.api.nvim_win_set_cursor(win, { row + 1, col })
  vim.api.nvim__redraw({ valid = false, flush = true, cursor = true })
end

function M.close(win_id)
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
  window.restore_cursor()
end

function M.clear_selector(bufnr)
  pcall(vim.api.nvim_clear_autocmds, { group = menu_group, buffer = bufnr })
  highlight.clear(bufnr)
end

function M.get_content_width(win_id)
  return vim.api.nvim_win_get_width(win_id) - 4
end

return M
