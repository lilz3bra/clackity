local M = {}

local ui = require("clackity.ui")
local word_list = require("clackity.core.wordlist")
local state = require("clackity.core.state")
local input = require("clackity.input")

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
  local win_width = vim.api.nvim_win_get_width(state.win_id) - 4
  local words = word_list.get_random_words(6)
  local lines = word_list.wrap_words(words, win_width)
  state.target_lines = lines
  ui.render_lines(state.bufnr, lines)

  input.attach_lesson(state.bufnr)
end

--- Input handler callback
function M.handle_input(key)
  local line_idx = state.current_row
  local col_idx = state.current_col

  local target_line = state.target_lines[line_idx + 1]

  if not target_line then return end

  local target_char = target_line:sub(col_idx + 1, col_idx + 1)

  local is_match = (key == target_char)
  if is_match then
    ui.mark_correct(state.bufnr, line_idx, col_idx)
  else
    ui.mark_error(state.bufnr, line_idx, col_idx)
  end

  state.current_col = state.current_col + 1

  if state.current_col >= #target_line then
    state.current_col = 0
    state.current_row = state.current_row + 1

    local next_line = state.target_lines[state.current_row + 1]
    if not next_line then
      -- TODO: implement post lesson screen
      M.post_lesson()
      return
    end
  end

  ui.move_cursor(state.win_id, state.current_row, state.current_col)
end

--- Show the end of lesson screen
function M.post_lesson()
  local stats_text = {
    "",
    "  LESSON COMPLETE  ",
    "",
    "   WPM:  ??          ",
    "   Acc:  ??%         ",
    "",
    " [r] Retry  [m] Menu [q] Quit"
  }
  ui.render_main(state.bufnr, stats_text)
  input.attach_post_lesson(state.bufnr)
end

--- Restart a lesson
function M.restart_lesson()
  state.reset()
  local win_width = vim.api.nvim_win_get_width(state.win_id) - 4
  local words = word_list.get_random_words(6)
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
