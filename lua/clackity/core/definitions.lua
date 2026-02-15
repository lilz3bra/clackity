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
--- @field consistency number

--- @class Clackity.state
--- @field bufnr number | nil
--- @field win_id number | nil
--- @field current_col number
--- @field current_row number
--- @field target_lines string[]
--- @field start_time number
--- @field last_key_time number
--- @field stats_log Clackity.state.lesson_log

--- @class Clackity.database.lesson
--- @field list_name string
--- @field keystrokes number
--- @field errors number
--- @field time number
