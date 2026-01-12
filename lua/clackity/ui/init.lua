local M = {}

local create_window = function(opts)
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
local core = require("clackity.core")

local original_cursor = ""
local function set_fake_cursor()
  original_cursor = vim.opt.guicursor:get()
  vim.opt.guicursor = "n:ver25-blinkon0"
end

local function restore_cursor()
  vim.opt.guicursor = original_cursor
end

M.start_window = function()
  local float = create_window()
  local words = core.get_words(4)
  local bufnr = float.buf

  -- Fix for global keymaps being finicky
  local augroup = vim.api.nvim_create_augroup("ClackityInputFix", { clear = true })
  local original_timeout = vim.o.timeoutlen

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    buffer = bufnr,
    group = augroup,
    callback = function()
      original_timeout = vim.o.timeoutlen
      vim.o.timeoutlen = 0
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = bufnr,
    group = augroup,
    callback = function()
      vim.o.timeoutlen = original_timeout
    end,
  })
  -- Rest of the ui logic
  core.bind_keys(float)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, words)
  set_fake_cursor()
  vim.api.nvim_set_option_value("virtualedit", "all", { scope = "local", win = float.win })
  vim.keymap.set("n", "<C-q>", function()
    vim.api.nvim_win_close(float.win, true)
    restore_cursor()
  end, { silent = true, buffer = bufnr })
end

return M
