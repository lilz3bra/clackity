local M = {}

local config = require("clackity.core.config")
local db = require("clackity.database")

local is_setup = false

--- @param opts? table User configuration overrides
function M.setup(opts)
  local has_sqlite, sqlite = pcall(require, "sqlite")
  if not has_sqlite then
    vim.notify("Clackity: sqlite.lua is required but not found. Please check :checkhealth",
      vim.log.levels.Error)
    return
  end
  config.setup(opts)
  is_setup = true
end

function M.Start()
  if not is_setup then M.setup({}) end
  db.init()
  require("clackity.core").start_plugin()
end

return M
