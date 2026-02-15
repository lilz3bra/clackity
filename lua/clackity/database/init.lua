local M = {}

local sqlite = require("sqlite.db")
local tbl = require("sqlite.tbl")
local DB_PATH = vim.fn.stdpath("data") .. "/clackity.db"
local db = nil

function M.init()
  db = sqlite({
    uri = DB_PATH,
    lessons = {
      id = { "integer", primary = true },
      list_name = "text",
      timestamp = { "timestamp", default = "CURRENT_TIMESTAMP" },
      keystrokes = "integer",
      errors = "integer",
      time = "integer",

      -- layout_id = "integer",
      -- telemetry_blob = "blob"
    },
  })
end

--- @param data Clackity.database.lesson
function M.save_lesson(data)
  if db then
    local lesson_id = db.lessons:insert(data)
    return
  end
end

return M
