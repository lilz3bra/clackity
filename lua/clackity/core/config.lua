local M = {}

local rules = require("clackity.rules")

--- @type Clackity.config.user
local user_defaults = {}

M.user_settings = vim.deepcopy(user_defaults)

--- @type Clackity.config.session
M.session_rules = { rules = {} }

local data_path = vim.fn.stdpath("data") .. "/clackity.json"

--- Initialize both the static user settings and the dynamic session state
function M.setup(user_opts)
  user_opts = user_opts or {}

  M.values = vim.tbl_deep_extend("force", user_defaults, user_opts)

  rules.setup()

  local dynamic_defaults = {}
  for key, rule in pairs(rules.registry) do
    dynamic_defaults[key] = rule.default
  end

  M.session_rules.rules = vim.deepcopy(dynamic_defaults)

  local f = io.open(data_path, "r")
  if f then
    local content = f:read("*a")
    f:close()

    local ok, saved_data = pcall(vim.fn.json_decode, content)
    if ok and saved_data and saved_data.rules then
      M.session_rules.rules = vim.tbl_deep_extend("force", M.session_rules.rules, saved_data)
    end
  end
end

--- Updates a session rule and immediately persist the state to json
--- @param key string The rule.key
--- @param value any The new value
function M.save_rule(key, value)
  M.session_rules.rules[key] = value

  local f = io.open(data_path, "w")
  if f then
    f:write(vim.fn.json_encode(M.session_rules))
    f:close()
  else
    vim.notify("Clackity: could not save config", vim.log.levels.ERROR)
  end
end

--- Extracts only the rules that are set to anything but their default
--- @return table<string, any>
function M.get_active_rules()
  local active_rules = {}
  for key, current_val in pairs(M.session_rules.rules) do
    local rule_blueprint = rules.registry[key]

    if rule_blueprint then
      if current_val ~= rule_blueprint.default
          and current_val ~= false
          and not rule_blueprint.db_ignore then
        active_rules[key] = current_val
      end
    end
  end

  return active_rules
end

return M
