local M = {}

local config = require("clackity.core.config")

function M.setup(opts)
  local has_sqlite, sqlite = pcall(require, "sqlite")
  if not has_sqlite then
    vim.notify("Clackity: sqlite.lua is required but not found. Please check :checkhealth",
      vim.log.levels.Error)
    return
  end

  config.setup(opts)
end

function M.Start()
  require("clackity.core").start_plugin()
end

return M
