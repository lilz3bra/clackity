local M = {}

M.start_window = function()
  local window = require("clackity.ui.window")
  local core = require("clackity.core")
  local highlight = require("clackity.ui.highlight")

  local float = window.create_window()
  local words = core.get_words(4)
  local bufnr = float.buf

  highlight.setup()
  window.buffer_keys_fix(bufnr)
  core.bind_keys(float)

  M.load_words(bufnr, words)

  for i, v in pairs(words) do
    highlight.paint(bufnr, "ClackityFuture", i - 1, 0, #v)
  end
  window.set_fake_cursor()

  vim.api.nvim_set_option_value("virtualedit", "all", { scope = "local", win = float.win })

  vim.keymap.set("n", "<C-r>", function()
    local new_words = core.get_words(4)
    M.load_words(bufnr, new_words)
  end, { silent = true, buffer = bufnr })

  vim.keymap.set("n", "<C-q>", function()
    vim.api.nvim_win_close(float.win, true)
    window.restore_cursor()
  end, { silent = true, buffer = bufnr })
end

M.load_words = function(buff, words)
  vim.api.nvim_buf_set_lines(buff, 0, -1, false, words)
end

return M
