local M = {}

local config = require("clackity.core.config")

function M.setup(opts)
  config.setup(opts)
end

function M.Start()
  require("clackity.core").start_plugin()
end

return M
