local M = {}

function M.attach(bufnr)
  local keys = "abcdefghijklmnopqrstuvwxyz"
  for i = 1, #keys do
    local char = keys:sub(i, i)
    vim.keymap.set("n", char, function()
      require("clackity.core").handle_input(char)
    end, { buffer = bufnr, nowait = true, noremap = true, silent = true })
  end

  vim.keymap.set("n", "<C-q>", function()
    local win = require("clackity.core.state").win_id
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
      require("clackity.ui.window").restore_cursor()
    end
  end, { buffer = bufnr })

  vim.keymap.set("n", "<C-r>", function()
    require("clackity.core").restart_game()
  end, { buffer = bufnr, silent = true })
end

return M
