local M = {}

function M.check()
  vim.health.start("Clackity Health Check")

  local has_sqlite, sqlite = pcall(require, "sqlite")
  if has_sqlite then
    vim.health.ok("sqlite.lua is installed")
  else
    vim.health.error("sqlite.lua not found. Please install 'kkharji/sqlite.lua'")
  end

  local data_path = vim.fn.stdpath("data") .. "/clackity.db"

  if vim.fn.filewritable(vim.fn.fnamemodify(data_path, ":p:h")) == 2 then
    vim.health.ok("Data directory is writable: " .. data_path)
  else
    vim.health.error("Data directory is not writable. Stats may not be saved")
  end
end

return M
