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

local function get_random_indices(qty, max)
  local indices = {}
  for i = 1, qty, 1 do
    indices[i] = math.random(max)
  end
  return indices
end

--- @param wordlist string: The wordlist to load
--- @return string[]: List of words
function M.load_wordlist(wordlist)
  local path = "wordlists/" .. wordlist .. ".txt"
  local words = {}

  local file = io.open(path, "r")

  if not file then
    vim.notify("Clackity: error opening wordlist", vim.log.levels.ERROR)
    return {}
  end

  for line in file:lines() do
    table.insert(words, line)
  end
  file:close()

  return words
end

--- Get an arbitrary number of words from the wordlist
--- @param qty number: Number of words to be returned
--- @param wordlist string[]: The loaded wordlist
--- @return string[]: Word array
function M.get_random_words(qty, wordlist)
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
