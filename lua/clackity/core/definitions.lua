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
--- @field user Clackity.config.user
--- @field session Clackity.config.session

--- @class Clackity.config.user Holds the user customizations accessible via their .lua config

--- @class Clackity.config.session Holds the user config made in the config menu
--- @field rules table<string,any>

--- @class Clackity.Rule.Hooks
--- @field on_load? fun(words: string[], value: any): string[] Modifies the wordlist before it wraps

--- @alias Clackity.InputType "toggle"|"number"|"text"|"select"|"multi_select"

--- @class Clackity.Rule
--- @field name string The display name for the UI menu
--- @field key string The internal session state and DB identifier
--- @field category string Menu grouping metadata (e.g., "wordlist")
--- @field input_type Clackity.InputType Tells the UI how to render this rule's menu
--- @field order? number The execution priority (lower runs first)
--- @field db_ignore? boolean If true this rule is excluded from the EAV table
--- @field default any The starting fallback value (boolean, number, string, or table of strings)
--- @field options? any[] Optional array of choices for 'select' or 'multi_select' types
--- @field hooks? Clackity.Rule.Hooks The logic to inject into the engine
