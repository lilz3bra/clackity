local M = {}

local state = require("clackity.core.state")
local ui = require("clackity.ui")

--- Get current time
local function now()
  return math.floor(vim.uv.hrtime() / 1e6)
end

--- Process a single process_keystroke
--- @param key string
--- @return boolean is_finished True if the lesson is complete
function M.process_keystroke(key)
  local line_idx = state.current_row
  local col_idx = state.current_col
  local current_time = now()

  if not state.start_time then
    state.start_time = current_time
    state.last_key_time = current_time
  end

  local target_line = state.target_lines[line_idx + 1]

  if not target_line then return true end

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

  --- @type Clackity.state.lesson_event
  local log = {
    target = target_char,
    actual = key,
    latency = latency,
    status = status
  }
  table.insert(state.stats_log, log)
  state.last_key_time = current_time

  if state.current_col >= #target_line then
    state.current_col = 0
    state.current_row = state.current_row + 1

    local next_line = state.target_lines[state.current_row + 1]
    if not next_line then
      return true
    end
  end

  ui.move_cursor(state.win_id, state.current_row, state.current_col)
  return false
end

return M
