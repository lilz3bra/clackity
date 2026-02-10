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
end

return M
