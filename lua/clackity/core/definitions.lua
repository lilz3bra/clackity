--- @alias KeyStatus "correct"|"error"

--- @class Clackity.state.lesson_log
--- @field target string
--- @field actual string
--- @field latency number
--- @field status KeyStatus

--- @class Clackity.stats.lesson
--- @field total_chars number
--- @field errors number
--- @field wpm number
--- @field accuracy number
--- @field time number
--- @field keys table

--- @class Clackity.state
--- @field bufnr number
--- @field win_id number
--- @field current_col number
--- @field current_row number
--- @field target_lines string[]
--- @field start_time number
--- @field last_key_time number
--- @field stats_log Clackity.state.lesson_log
