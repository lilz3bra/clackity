local M = {}

local ui = require("clackity.ui")
local word_list = require("clackity.core.wordlist")
local state = require("clackity.core.state")
local input = require("clackity.input")
local config = require("clackity.core.config")
local stats = require("clackity.stats")


--- Entry point
function M.start_plugin()
  local floats = ui.create_window()

  state.bufnr = floats.buf
  state.win_id = floats.win

  M.show_menu()
end

--- Launch the main menu
function M.show_menu()
  state.reset()
  ui.render_main(state.bufnr, {
    "",
    "   CLACKITY TYPE   ",
    "   -------------   ",
    "",
    " [Enter] Start Lesson",
    " [s]     Stats       ",
    " [q]     Quit        "
  })

  -- Switch input mode to Menu
  input.attach_main(state.bufnr)
end

--- Launch a new lesson window
function M.start_lesson()
  state.reset()
  local word_count = config.values.word_count
  local win_width = vim.api.nvim_win_get_width(state.win_id) - 4
  local words = word_list.get_random_words(word_count)
  local lines = word_list.wrap_words(words, win_width)
  state.target_lines = lines
  ui.render_lines(state.bufnr, lines)

  input.attach_lesson(state.bufnr)
end

--- Get current time
local function now()
  return vim.loop.hrtime() / 1e6
end

--- Input handler callback
function M.handle_input(key)
  local line_idx = state.current_row
  local col_idx = state.current_col
  local current_time = now()

  if not state.start_time then
    state.start_time = current_time
    state.last_key_time = current_time
  end

  local target_line = state.target_lines[line_idx + 1]

  if not target_line then return end

  local target_char = target_line:sub(col_idx + 1, col_idx + 1)

  local is_match = (key == target_char)
  local status = is_match and "correct" or "error"

  if is_match then
    ui.mark_correct(state.bufnr, line_idx, col_idx)
  else
    ui.mark_error(state.bufnr, line_idx, col_idx)
  end

  local latency = current_time - state.last_key_time

  state.current_col = state.current_col + 1

  --- @type Clackity.state.lesson_log
  local log = {
    target = target_char,
    actual = key,
    latency = latency,
    status = status
  }
  table.insert(state.stats_log, log)
  print(log.latency)
  state.last_key_time = current_time

  if state.current_col >= #target_line then
    state.current_col = 0
    state.current_row = state.current_row + 1

    local next_line = state.target_lines[state.current_row + 1]
    if not next_line then
      M.post_lesson()
      return
    end
  end

  ui.move_cursor(state.win_id, state.current_row, state.current_col)
end

--- Show the end of lesson screen
function M.post_lesson()
  --- @type Clackity.stats.lesson
  local lesson_stats = stats.lesson_stats(state.stats_log)
  local stats_text = {
    "",
    "  LESSON COMPLETE  ",
    "",
    "   Keys:   " .. lesson_stats.total_chars,
    "   Errors: " .. lesson_stats.errors,
    "   WPM:    " .. lesson_stats.wpm,
    "   Time:   " .. lesson_stats.time .. " seconds",
    "   Acc:    " .. lesson_stats.accuracy .. " %",
    "",
    " [r] Retry  [m] Menu [q] Quit"
  }
  ui.render_main(state.bufnr, stats_text)
  input.attach_post_lesson(state.bufnr)
end

--- Restart a lesson
function M.restart_lesson()
  state.reset()
  local word_count = config.values.word_count
  local win_width = vim.api.nvim_win_get_width(state.win_id) - 4
  local words = word_list.get_random_words(word_count)
  local lines = word_list.wrap_words(words, win_width)
  state.target_lines = lines

  ui.render_lines(state.bufnr, lines)
  ui.move_cursor(state.win_id, 0, 0)
  input.attach_lesson(state.bufnr)
end

--- Cleanup and quit
function M.quit()
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
    vim.api.nvim_win_close(state.win_id, true)
  end
  require("clackity.ui.window").restore_cursor()
end

return M
