local M = {}

local ui = require("clackity.ui")
local word_list = require("clackity.wordlist")
local state = require("clackity.core.state")
local input = require("clackity.input")
local config = require("clackity.core.config")
local stats = require("clackity.stats")
local db = require("clackity.database")
local handler = require("clackity.core.handler")

--- Entry point
function M.start_plugin()
  local floats = ui.create_window()

  state.bufnr = floats.buf
  state.win_id = floats.win

  M.show_menu()
end

--- Launch the main menu
function M.show_menu()
  state.reset()
  ui.draw_menu(state.bufnr)

  -- Switch input mode to Menu
  input.attach_main(state.bufnr)
end

--- Launch a new lesson window
function M.start_lesson()
  state.reset()
  local word_count = config.values.word_count

  --- @type Clackity.config.wordlist
  local wordlist_config = config.values.wordlist_config
  local list = word_list.load_wordlist(wordlist_config.current_wordlist)

  local words = word_list.get_random_words(word_count, list)
  local win_width = ui.get_content_width(state.win_id)
  local lines = word_list.wrap_words(words, win_width)
  state.target_lines = lines
  ui.render_lines(state.bufnr, lines)
  ui.move_cursor(state.win_id, 0, 0)
  input.attach_lesson(state.bufnr)
end

--- Input handler callback
function M.handle_input(key)
  local is_finished = handler.process_keystroke(key)
  if is_finished then M.post_lesson() end
end

--- Show the end of lesson screen
function M.post_lesson()
  --- @type Clackity.stats.lesson
  local lesson_stats = stats.lesson_stats(state.stats_log)

  ui.draw_post_lesson(state.bufnr, lesson_stats)

  input.attach_post_lesson(state.bufnr)
  --- @type Clackity.database.lesson
  local tbl_data = {
    list_name = "default",
    time = lesson_stats.time,
    errors = lesson_stats.errors,
    characters = lesson_stats.total_chars,
    square_time = lesson_stats.square_time
  }
  db.save_lesson(tbl_data, lesson_stats.keys)
end

function M.wordlist_config()
  local header_offset = 4
  local wordlist_config = config.values.wordlist_config

  local opts = {
    string.format("Wordlist: [ %s ]", wordlist_config.current_wordlist),
    "Casing",
    "Filter words"
  }
  ui.draw_selector(state.bufnr, state.win_id, "WORDLIST CONFIG", opts)

  local actions = {
    select = function()
      local physical_row = vim.api.nvim_win_get_cursor(0)[1]
      local array_index = physical_row - header_offset

      if array_index == 1 then
        ui.clear_selector(state.bufnr)
        M.wordlist_select()
      elseif array_index == 2 then
        vim.notify("Casing menu coming soon!")
      elseif array_index == 3 then
        vim.notify("Filter menu coming soon!")
      end
    end,
    back = function()
      ui.clear_selector(state.bufnr)
      M.show_menu()
    end
  }

  input.attach_selector(state.bufnr, actions)
end

function M.wordlist_select()
  local current_val = config.values.wordlist_config.current_wordlist

  local raw_lists = word_list.get_available_lists()
  local display_opts = { current_val }
  for _, list in ipairs(raw_lists) do
    if list ~= current_val then table.insert(display_opts, list) end
  end

  local header_offset = 4

  ui.draw_selector(state.bufnr, state.win_id, "SELECT WORDLIST", display_opts)

  local actions = {
    select = function()
      local physical_row = vim.api.nvim_win_get_cursor(0)[1]

      local array_index = physical_row - header_offset

      if array_index >= 1 and array_index <= #display_opts then
        local chosen_value = display_opts[array_index]

        local new_config = vim.deepcopy(config.values.wordlist_config)
        new_config.current_wordlist = chosen_value
        config.save("wordlist_config", new_config)

        M.wordlist_config()
      end
    end,
    back = function()
      ui.clear_selector(state.bufnr)
      M.wordlist_config()
    end
  }

  input.attach_selector(state.bufnr, actions)
end

--- Cleanup and quit
function M.quit()
  ui.close(state.win_id)
end

return M
