local M = {}

M.ns_id = vim.api.nvim_create_namespace("ClackityHighlights")

local default_colors = {
  future = { link = "Comment", default = true },
  correct = { link = "Normal", default = true },
  error = { link = "Error", default = true },
  selection = { link = "CursorLine", default = true },
}

--- @param opts? table User-defined highlight groups overrides
function M.setup(opts)
  opts = opts or {}

  local future_opts = opts.future or default_colors.future
  vim.api.nvim_set_hl(0, "ClackityFuture", future_opts)
  local correct_opts = opts.correct or default_colors.correct
  vim.api.nvim_set_hl(0, "ClackityCorrect", correct_opts)
  local error_opts = opts.error or default_colors.error
  vim.api.nvim_set_hl(0, "ClackityError", error_opts)
  local sel_opts = opts.selection or default_colors.selection
  vim.api.nvim_set_hl(0, "ClackitySelection", sel_opts)
end

--- Paints a specific character range on a specific line
--- @param buf number
--- @param group string The highlight group name (e.g. "ClackityCorrect")
--- @param line number 0-indexed line number
--- @param col_start number 0-indexed start byte
--- @param col_end number 0-indexed end byte
function M.paint(buf, group, line, col_start, col_end)
  vim.hl.range(buf, M.ns_id, group, { line, col_start }, { line, col_end }, {
    priority = 200,
    strict = false,
  })
end

--- Applies a highlight to an entire line (used for menu selection)
--- @param buf number
--- @param group string
--- @param line_idx number
function M.paint_line(buf, group, line_idx)
  vim.api.nvim_buf_set_extmark(buf, M.ns_id, line_idx, 0, {
    line_hl_group = group,
    priority = 200,
  })
end

--- @param buf number
function M.clear(buf)
  vim.api.nvim_buf_clear_namespace(buf, M.ns_id, 0, -1)
end

return M
