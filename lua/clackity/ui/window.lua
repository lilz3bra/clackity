local M = {}

M.create_window = function(opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns / 2)
  local height = math.floor((vim.o.lines - 4) / 2)

  local col = (vim.o.columns - width) / 2
  local row = (vim.o.lines - height) / 2

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    col = col,
    row = row,
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

M.buffer_keys_fix = function(bufnr)
  local augroup = vim.api.nvim_create_augroup("ClackityInputFix", { clear = true })
  local original_timeout = vim.o.timeoutlen
  local original_ttimeout = vim.o.ttimeoutlen

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    buffer = bufnr,
    group = augroup,
    callback = function()
      original_timeout = vim.o.timeoutlen
      original_ttimeout = vim.o.ttimeoutlen
      vim.o.ttimeoutlen = 0
      vim.o.timeoutlen = 0
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = bufnr,
    group = augroup,
    callback = function()
      vim.o.timeoutlen = original_timeout
      vim.o.ttimeoutlen = original_ttimeout
    end,
  })

  vim.o.ttimeoutlen = 0
  vim.o.timeoutlen = 0
end

local original_cursor = ""

M.restore_cursor = function()
  print("restoring cursor")
  vim.opt.guicursor = original_cursor
end

M.set_fake_cursor = function()
  original_cursor = vim.opt.guicursor:get()
  vim.opt.guicursor = "n:ver25-blinkon0"
  return original_cursor
end

return M
