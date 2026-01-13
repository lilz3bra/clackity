local M = {}

M.start_window = function()
  local window = require("clackity.ui.window")
  local core = require("clackity.core")

  local float = window.create_window()
  local words = core.get_words(4)
  local bufnr = float.buf

  window.buffer_keys_fix(bufnr)

  core.bind_keys(float)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, words)
  window.set_fake_cursor()

  vim.api.nvim_set_option_value("virtualedit", "all", { scope = "local", win = float.win })
  print(vim.o.timeoutlen, vim.o.ttimeoutlen)
  vim.keymap.set("n", "<C-q>", function()
    vim.api.nvim_win_close(float.win, true)
    window.restore_cursor()
  end, { silent = true, buffer = bufnr })
end

return M
