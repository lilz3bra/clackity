--- @class Clackity.state
local M = {
  bufnr = nil,
  win_id = nil,
  current_col = 0,
  current_row = 0,
  target_lines = {},
  start_time = nil,
  last_key_time = nil,
  stats_log = {}
}

function M.reset()
  M.current_row = 0
  M.current_col = 0
  M.target_lines = {}
  M.start_time = nil
  M.last_key_time = nil
  M.stats_log = {}
end

return M
