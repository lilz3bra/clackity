local M = {}

--- Scans the runtime path for available wordlist files
--- @return string[]: List of filenames (without .txt)
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

--- @param wordlist string: The wordlist to load
--- @return string[]: List of words
function M.load_wordlist(wordlist)
  local path = "wordlists/" .. wordlist .. ".txt"
  local matches = vim.api.nvim_get_runtime_file(path, false)

  if #matches == 0 then
    vim.notify("Clackity: could not find wordlist" .. wordlist, vim.log.levels.ERROR)
    return {}
  end

  local absolute_path = matches[1]
  if not absolute_path then return {} end
  local words = {}

  local file = io.open(absolute_path, "r")

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

--- Pack words into lines based on window max_width
--- @param words string[]: The wordlist to pack
--- @param max_width number: The width to wrap at
--- @return string[]
function M.wrap_words(words, max_width)
  local lines = {}
  local current_line = ""

  for _, word in ipairs(words) do
    if #current_line + #word + 1 > max_width then
      if #current_line > 0 then
        table.insert(lines, current_line .. " ")
      end
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
