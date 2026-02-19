local M = {}

local sqlite = require("sqlite.db")
-- local tbl = require("sqlite.tbl")
local DB_PATH = vim.fn.stdpath("data") .. "/clackity.db"
local db = nil

function M.init()
  db = sqlite({
    uri = DB_PATH,
    lessons = {
      id = { "integer", primary = true },
      list_name = "text",
      layot = "text",
      timestamp = { "timestamp", default = "CURRENT_TIMESTAMP" },
      characters = "integer",
      errors = "integer",
      time = "integer",
      square_time = "integer"
    },
    lesson_keys = {
      lesson_id = { "integer", reference = "lessons.id", on_delete = "cascade" },
      char = "text",
      appearances = "integer",
      errors = "integer",
      time = "real",
      square_time = "real"
    },
    lesson_history = {
      id = { "integer", primary = true },
      list_name = "text",
      layout = "text",
      start_ts = "timestamp",
      end_ts = "timestamp",
      lesson_qty = "integer",
      characters = "integer",
      errors = "integer",
      time = "integer",
      square_time = "integer"
    },
    lesson_key_history = {
      lesson_history_id = { "integer", reference = "lesson_history.id", on_delete = "cascade" },
      char = "text",
      appearances = "integer",
      errors = "integer",
      time = "real",
      square_time = "real"
    },
  })
end

--- @param data Clackity.database.lesson
--- @param key_stats Clackity.database.lesson_key[]
function M.save_lesson(data, key_stats)
  if not db then return end

  local ok, err = pcall(function()
    local lesson_id = db.lessons:insert(data)

    ---@type Clackity.database.lesson_key[]
    local keys_to_insert = {}

    for char, stats in pairs(key_stats) do
      table.insert(keys_to_insert, {
        lesson_id = lesson_id,
        char = char,
        errors = stats.errors,
        time = stats.time,
        appearances = stats.appearances,
        square_time = stats.square_time
      })
    end

    db.lesson_keys:insert(keys_to_insert)
  end)

  if not ok then
    vim.notify("Clackity: DB insert error: " .. tostring(err), vim.log.levels.ERROR)
  end
end

return M
