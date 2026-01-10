local M = {}

local words = require("clackity.core.wordlist")

function M.get_words(qty)
  print(words)
  local w = words.get_random_words(qty)
  return w
end

return M
