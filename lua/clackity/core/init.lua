local M = {}

local words = require("clackity.core.wordlist")

function M.get_words(qty)
  local w = words.get_random_words(qty)
  return w
end

function M.bind_keys(buf)
  local keybind = require("clackity.core.keymap")
  keybind.load_keys(buf)
end

local state = require("clackity.core.state")

return M
