local M = {}
M.db = require('sqlite.db')

M.tutor_db("~/.local/share/nvim/clackity.db", {
  sessions = {
    id = { 'integer', primary = true },
    date = "text",
    wpm = "real",
    accuracy = "real"
  },
  key_data = {
    id = { "integer", primary = true },
    session_id = { "integer", reference = "sessions.id" },
    key = "text",
    latency = "real",
  }
})

M.tutor_db:insert({
  date = os.date("%Y-%m-%d %H:%M:%S"),
  wpm = 36.7,
  accuracy = 100
})
return M
