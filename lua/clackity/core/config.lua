local M = {}
---@type Clackity.config
local defaults = {
  word_count = 20,
  wordlist = {
    current = "en_1k_common",
  }
}

M.values = vim.deepcopy(defaults)

local data_path = vim.fn.stdpath("data") .. "/clackity.json"

--- Load config: Defaults -> Setup opts -> Saved data
function M.setup(user_opts)
  user_opts = user_opts or {}

  M.values = vim.tbl_deep_extend("force", defaults, user_opts)

  local f = io.open(data_path, "r")

  if f then
    local content = f:read("*a")
    f:close()

    local ok, saved_data = pcall(vim.fn.json_decode, content)
    if ok and saved_data then
      M.values = vim.tbl_deep_extend("force", M.values, saved_data)
    end
  end
end

function M.save(key, value)
  M.values[key] = value

  local f = io.open(data_path, "w")
  if f then
    f:write(vim.fn.json_encode(M.values))
    f:close()
  else
    vim.notify("Clackity: could not save config", vim.log.levels.ERROR)
  end
end

return M
