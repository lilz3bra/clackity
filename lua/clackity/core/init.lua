local M = {}

local ui = require("clackity.ui")
local word_list = require("clackity.wordlist")
local state = require("clackity.core.state")
local input = require("clackity.input")
local config = require("clackity.core.config")
local stats = require("clackity.stats")
local db = require("clackity.database")
local handler = require("clackity.core.handler")
local rules = require("clackity.rules")

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

  input.attach_main(state.bufnr)
end

--- Launch a new lesson window
function M.start_lesson()
  state.reset()

  rules.resolve_active_hooks(config.session_rules.rules)

  local list_name = config.session_rules.rules["wordlist"] or "en_1k_common"
  local raw_words = word_list.load_wordlist(list_name)
  local final_words = rules.run_load_hooks(raw_words)

  local win_width = ui.get_content_width(state.win_id)
  local lines = word_list.wrap_words(final_words, win_width)

  state.target_lines = lines
  ui.render_lines(state.bufnr, lines)
  ui.move_cursor(state.win_id, 0, 0)

  local actions = {
    on_quit = M.quit,
    on_menu = M.show_menu,
    on_restart = M.start_lesson,
    on_keystroke = function(char)
      local is_finished = handler.process_keystroke(char)

      if is_finished then
        vim.schedule(function()
          M.post_lesson()
        end)
      end

      return is_finished
    end
  }

  input.attach_lesson(state.bufnr, actions)
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
    list_name = config.session_rules.rules["wordlist"],
    layout = "default",
    time = lesson_stats.time,
    errors = lesson_stats.errors,
    characters = lesson_stats.total_chars,
    square_time = lesson_stats.square_time
  }

  local active_rules = config.get_active_rules()
  db.save_lesson(tbl_data, lesson_stats.keys, active_rules)
end

--- Show the config menu
function M.show_config_menu()
  local opts = {}
  local rules_on_row = {}
  local grouped_rules = {}
  for _, rule in pairs(rules.registry) do
    grouped_rules[rule.category] = grouped_rules[rule.category] or {}
    table.insert(grouped_rules[rule.category], rule)
  end

  local categories = vim.tbl_keys(grouped_rules)
  table.sort(categories)

  for _, category in ipairs(categories) do
    table.insert(opts, "---" .. string.upper(category) .. "---")
    table.insert(rules_on_row, nil)

    table.sort(grouped_rules[category], function(a, b) return a.name < b.name end)

    for _, rule in ipairs(grouped_rules[category]) do
      local current_val = config.session_rules.rules[rule.key]
      local display_val = current_val

      if type(current_val) == table then
        display_val = table.concat(current_val, ",")
        if display_val == "" then display_val = "None" end
      end

      table.insert(opts, string.format(" %s: [ %s ]", rule.name, tostring(display_val)))
      table.insert(rules_on_row, rule)
    end
    table.insert(opts, "")
    table.insert(rules_on_row, nil)
  end

  ui.draw_selector(state.bufnr, state.win_id, "CONFIGURATION", opts)

  local header_offset = 5
  local actions = {
    select = function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local idx = row - header_offset

      local selected_rule = rules_on_row[idx]

      if not selected_rule then return end

      ui.clear_selector(state.bufnr)

      if selected_rule.input_type == "toggle" then
        local current = config.session_rules.rules[selected_rule.key]
        config.save_rule(selected_rule.key, not current)
        M.show_config_menu() -- Refresh UI
      elseif selected_rule.input_type == "select" then
        M.show_options_selector(selected_rule)
      elseif selected_rule.input_type == "number" or selected_rule.input_type == "text" then
        vim.ui.input({
          prompt = "Enter new value for " .. selected_rule.name .. ": ",
          default = tostring(config.session_rules.rules[selected_rule.key])
        }, function(input_val)
          if input_val then
            if selected_rule.input_type == "number" then
              input_val = tonumber(input_val) or config.session_rules.rules[selected_rule.key]
            end
            config.save_rule(selected_rule.key, input_val)
          end
          M.show_config_menu()
        end)
      elseif selected_rule.input_type == "multi_select" then
        vim.notify("Multi-select UI coming soon!")
        M.show_config_menu()
      end
    end,
    back = function()
      ui.clear_selector(state.bufnr)
      M.show_menu()
    end
  }

  input.attach_selector(state.bufnr, actions)
end

--- Sub-menu strictly for rules with an `options` array (Returns to unified config)
function M.show_options_selector(rule)
  local opts = rule.options or {}
  ui.draw_selector(state.bufnr, state.win_id, string.upper(rule.name), opts)

  local header_offset = 4
  local actions = {
    select = function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local idx = row - header_offset

      if idx >= 1 and idx <= #opts then
        config.save_rule(rule.key, opts[idx])
      end

      ui.clear_selector(state.bufnr)
      M.show_config_menu()
    end,
    back = function()
      ui.clear_selector(state.bufnr)
      M.show_config_menu()
    end
  }
  input.attach_selector(state.bufnr, actions)
end

--- Show the wordlist config menu
function M.wordlist_config()
  local header_offset = 4
  local cfg = config.values.wordlist

  local opts = {
    string.format("Wordlist: [ %s ]", cfg.current),
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

--- Show the wordlist selector
function M.wordlist_select()
  local current_val = config.values.wordlist.current

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

        local new_config = vim.deepcopy(config.values.wordlist)
        new_config.current = chosen_value
        config.save("wordlist", new_config)

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
