local M = {}

--- Calculate the lesson stats from a lesson log
--- @param lesson_log Clackity.lesson_log
--- @return Clackity.stats.lesson
function M.calculate_stats(lesson_log)
  local summary = {
    total_chars = 0,
    errors = 0,
    wpm = 0,
    accuracy = 0,
    keys = {}
  }
  for _, event in ipairs(lesson_log) do
    summary.total_chars = summary.total_chars + 1

    if event.status == "error" then
      summary.errors = summary.errors + 1
    end
  end

  return summary
end

return M
