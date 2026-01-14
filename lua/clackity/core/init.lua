local M = {}

local ui = require("clackity.ui")
local word_list = require("clackity.core.wordlist")
local state = require("clackity.core.state")
local input = require("clackity.input")

function M.start_plugin()
  state.reset()

  local floats = ui.create_main_window()
  state.bufnr = floats.buf
  state.win_id = floats.win

  local words = word_list.get_random_words(6)
  state.target_lines = words

  ui.render_lines(state.bufnr, words)

  input.attach(state.bufnr)
end

M.handle_input = function(key)
  local line_idx = state.current_row
  local col_idx = state.current_col

  local target_line = state.target_lines[line_idx + 1]

  if not target_line then
    return
  end

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
      print("Finished")
      return
    end
  end

  ui.move_cursor(state.win_id, state.current_row, state.current_col)
end

function M.restart_game()
  state.reset()
  local words = word_list.get_random_words(6)
  ui.render_lines(state.bufnr, words)
  ui.move_cursor(state.win_id, 0, 0)
end

return M
