local M = {}

function create_floating_window(opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)

  local width = vim.o.columns / 2
  local height = vim.o.lines - 4

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    style = "minimal",
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    col = 8,
    row = 4,
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

M.start_window = function()
  local ui = clackity.ui
  local float = create_floating_window()

  vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, {"Hello world"})
  vim.keymap.set("n", "q", function ()
    vim.api.nvim_win_close(float.win, true)
  end)
end

return M

