local M = {}

--- @type string[]
local wordlist = { "the", "quick", "brown", "fox", "jumped", "over", "lazy", "dog" }

local get_random_indices = function(qty, max)
  local indices = {}
  for i = 1, qty, 1 do
    indices[i] = math.random(max)
  end
  return indices
end

--- Get an arbitrary number of words from the wordlist
--- @param qty number: Number of words to be returned
--- @return string[]: Word array
function M.get_random_words(qty)
  local words = {}
  if qty > #wordlist then
    words = wordlist
  else
    local idxs = get_random_indices(qty, #wordlist)
    for i, v in ipairs(idxs) do
      words[i] = wordlist[v]
    end
  end
  return words
end

return M
