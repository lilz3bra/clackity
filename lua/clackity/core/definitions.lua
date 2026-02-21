--- @class Clackity.stats.lesson
--- @field total_chars number
--- @field errors number
--- @field wpm number
--- @field accuracy number
--- @field time number
--- @field square_time number
--- @field keys table<string, Clackity.stats.key_stats>
--- @field consistency number

--- @class Clackity.stats.key_stats
--- @field appearances number
--- @field errors number
--- @field time number
--- @field square_time number

--- @alias KeyStatus "correct"|"error"

--- @class Clackity.state.lesson_event
--- @field target string
--- @field actual string
--- @field latency number
--- @field status KeyStatus

--- @class Clackity.state
--- @field bufnr? number
--- @field win_id? number
--- @field current_col number
--- @field current_row number
--- @field target_lines string[]
--- @field start_time? number
--- @field last_key_time? number
--- @field stats_log Clackity.state.lesson_event[]

--- @class Clackity.database.lesson
--- @field list_name string
--- @field characters number
--- @field errors number
--- @field time number
--- @field square_time number

--- @class Clackity.database.lesson_key
--- @field lesson_id number
--- @field char string
--- @field appearances number
--- @field errors number
--- @field time number
--- @field square_time number

--- @class Clackity.config
--- @field word_count number
--- @field wordlist Clackity.config.wordlist

--- @class Clackity.config.wordlist
--- @field current string
