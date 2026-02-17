local M = {}

--- Calculate the lesson stats from a lesson log
--- @param lesson_log Clackity.state.lesson_event[]
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
  local iki_count = 0

  --- @type table<string, Clackity.stats.key_stats>
  local key_stats = {}

  for i, event in ipairs(lesson_log) do
    total_chars = total_chars + 1
    time = time + event.latency

    local char = event.target
    if not key_stats[char] then
      key_stats[char] = {
        appearances = 0,
        errors = 0,
        time = 0,
        square_time = 0
      }
    end

    key_stats[char].appearances = key_stats[char].appearances + 1
    key_stats[char].time = key_stats[char].time + event.latency

    if i > 1 then
      iki_count = iki_count + 1
      square_sum = square_sum + event.latency ^ 2
      key_stats[char].square_time = key_stats[char].square_time + event.latency ^ 2
    end
    if event.status == "error" then
      errors = errors + 1
      key_stats[char].errors = key_stats[char].errors + 1
    end
  end

  if iki_count > 0 then
    mean = time / iki_count
    variance = (square_sum / iki_count) - mean ^ 2
    sd = math.sqrt(math.max(0, variance))

    if mean > 0 then
      local cv = sd / mean
      consistency = (1 - cv) * 100
    else
      consistency = 100
    end
  else
    consistency = 100
  end

  wpm = (total_chars / 5) / (time / 6e4)
  accuracy = (1 - errors / total_chars) * 100

  --- @type Clackity.stats.lesson
  local summary = {
    total_chars = total_chars,
    errors = errors,
    wpm = wpm,
    accuracy = accuracy,
    time = time,
    keys = key_stats,
    consistency = consistency,
    square_time = square_sum
  }
  return summary
end

return M
