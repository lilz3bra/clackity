local M = {}

local create_window = function(opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns / 2)
  local height = math.floor((vim.o.lines - 4) / 2)

  local col = (vim.o.columns - width) / 2
  local row = (vim.o.lines - height) / 2
  print(width)
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    style = "minimal",
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    col = col,
    row = row,
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

M.start_window = function()
  local float = create_window()

  vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, { "Hello world" })
  vim.keymap.set("n", "q", function()
    M.cleanup(float.win)
  end)
end

M.cleanup = function(win)
  vim.keymap.del("n", "q", { 0 })

  vim.api.nvim_win_close(win, true)
end

return M
