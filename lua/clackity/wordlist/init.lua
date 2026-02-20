local M = {}

function M.get_available_lists()
  local files = vim.api.nvim_get_runtime_file("wordlists/*.txt", true)
  local lists = {}

  for _, file in ipairs(files) do
    local basename = vim.fn.fnamemodify(file, ":t:r")
    table.insert(lists, basename)
  end

  if #lists == 0 then
    table.insert(lists, "en_1k_common")
  end

  return lists
end

local get_random_indices = function(qty, max)
  local indices = {}
  for i = 1, qty, 1 do
    indices[i] = math.random(max)
  end
  return indices
end


--- TODO: implement using the loaded list instead of the old hardcoded one
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

--- Pack words into lines based on window max_width
--- @param words string[]: The wordlist to pack
--- @param max_width number: The width to wrap at
--- @return string[]
function M.wrap_words(words, max_width)
  local lines = {}
  local current_line = ""

  for _, word in ipairs(words) do
    if #current_line + #word + 1 > max_width then
      current_line = current_line .. " "
      table.insert(lines, current_line)
      current_line = word
    else
      if #current_line > 0 then
        current_line = current_line .. " " .. word
      else
        current_line = word
      end
    end
  end

  if #current_line > 0 then
    table.insert(lines, current_line)
  end

  return lines
end

return M
