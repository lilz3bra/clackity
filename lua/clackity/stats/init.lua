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

  local mean = 0
  local sd = 0
  local variance = 0
  local consistency = 0
  local square_sum = 0
  local iki_count = 1

  for i, event in ipairs(lesson_log) do
    total_chars = total_chars + 1
    time = time + event.latency
    if i > 1 then
      iki_count = iki_count + 1
      square_sum = square_sum + event.latency ^ 2
    end
    if event.status == "error" then
      errors = errors + 1
    end
  end

  mean = time / total_chars
  time = time / 1000

  variance = (square_sum / total_chars) - mean ^ 2
  sd = math.sqrt(math.max(0, variance))
  local cv = sd / mean
  consistency = (1 - cv) * 100

  wpm = (total_chars / 5) / (time / 60)
  accuracy = (1 - errors / total_chars) * 100
  print(mean .. " " .. variance .. " " .. sd .. " " .. consistency)
  --- @type Clackity.stats.lesson
  local summary = {
    total_chars = total_chars,
    errors = errors,
    wpm = wpm,
    accuracy = accuracy,
    time = time,
    keys = {},
    consistency = consistency
  }
  return summary
end

return M
