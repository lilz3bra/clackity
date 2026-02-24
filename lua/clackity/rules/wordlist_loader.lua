local word_list = require("clackity.wordlist")

--- @type Clackity.Rule
local M = {
  name = "Wordlist",
  key = "wordlist",
  category = "wordlist",
  input_type = "select",
  order = 10,
  db_ignore = true,
  default = "en_1k_common",
  options = word_list.get_available_lists(),
  hooks = {}
}

return M
