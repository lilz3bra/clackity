local M = {}

--- Calculate the lesson stats from a lesson log
--- @param lesson_log Clackity.state.lesson_log
--- @return Clackity.stats.lesson
function M.lesson_stats(lesson_log)
  local time = 0
  local wpm = 0
  local errors = 0
  local total_chars = 0
  local accuracy = 0

  for _, event in ipairs(lesson_log) do
    total_chars = total_chars + 1
    time = time + event.latency
    if event.status == "error" then
      errors = errors + 1
    end
  end

  time = time / 1000
  wpm = (total_chars / 5) / (time / 60)
  accuracy = (1 - errors / total_chars) * 100

  --- @type Clackity.stats.lesson
  local summary = {
    total_chars = total_chars,
    errors = errors,
    wpm = wpm,
    accuracy = accuracy,
    time = time,
    keys = {}
  }
  return summary
end

return M
