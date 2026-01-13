local M = {}

M.ns_id = vim.api.nvim_create_namespace("ClackityHighlights")

function M.setup()
  vim.api.nvim_set_hl(0, "ClackityFuture", { link = "Comment", default = true })
  vim.api.nvim_set_hl(0, "ClackityCorrect", { link = "Normal", default = true })
  vim.api.nvim_set_hl(0, "ClackityError", { link = "Error", default = true })
end

function M.paint(buf, group, line, col_start, col_end)
  vim.api.nvim_buf_add_highlight(buf, M.ns_id, group, line, col_start, col_end)
end

function M.clear(buf)
  vim.api.nvim_buf_clear_namespace(buf, M.ns_id, 0, -1)
end

return M
