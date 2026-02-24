--- @type Clackity.Rule
local M = {
  name = "Word count",
  key = "word_count",
  category = "wordlist",
  input_type = "number",
  order = 90,
  default = 20,
  hooks = {
    on_load = function(words, value)
      local result = {}
      local total_words = #words

      if total_words == 0 then return result end

      for _ = 1, value do
        local random_index = math.random(1, total_words)
        table.insert(result, words[random_index])
      end
      return result
    end
  }
}
return M
