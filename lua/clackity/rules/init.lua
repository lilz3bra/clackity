local M = {}

--- @type table<string, Clackity.Rule>
M.registry = {}

M.active_hooks = {
  on_load = {},
}

--- Scans the rules dir and populates the registry blueprint
function M.setup()
  local plugin_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h")
  local files = vim.fn.split(vim.fn.globpath(plugin_root, "*.lua"), "\n")

  for _, file in ipairs(files) do
    local module_name = vim.fn.fnamemodify(file, ":t:r")
    if module_name ~= "init" then
      local rule = require("clackity.rules." .. module_name)
      M.registry[rule.key] = rule
    end
  end
end

--- Resolves which rules are active for the current session and builds the callback pipeline.
--- Called once at the start of the lesson
--- @param session_rules table<string, any> The live config.session.rules
function M.resolve_active_hooks(session_rules)
  M.active_hooks.on_load = {}

  local unsorted_on_load = {}

  for rule_key, rule in pairs(M.registry) do
    local current_val = session_rules[rule_key]

    if current_val == nil then current_val = rule.default end

    if rule.hooks and rule.hooks.on_load then
      if current_val ~= false then
        table.insert(unsorted_on_load, {
          order = rule.order or 50,
          fn = function(words)
            return rule.hooks.on_load(words, current_val)
          end
        })
      end
    end
  end

  -- Sort the temp table by the priority
  table.sort(unsorted_on_load, function(a, b)
    return a.order < b.order
  end)

  -- Exctract the closures into the final array
  for _, item in ipairs(unsorted_on_load) do
    table.insert(M.active_hooks.on_load, item.fn)
  end
end

--- Executes all the active on_load callbacks sequentially
--- @param words string[]
--- @return string[]
function M.run_load_hooks(words)
  local result = words

  for _, callback in ipairs(M.active_hooks.on_load) do
    local new_result = callback(result)

    if type(new_result) ~= "table" then
      vim.notify(
        "Clackity: A wordlist rule failed (returned " .. type(new_result) .. " instead of table). Ignoring rule.",
        vim.log.levels.WARN)
    else
      result = new_result
    end
  end

  return result
end

return M
