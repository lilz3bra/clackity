--- @type Clackity.Rule

local accent_map = {
  ["á"] = "a",
  ["à"] = "a",
  ["ä"] = "a",
  ["â"] = "a",
  ["ã"] = "a",
  ["å"] = "a",
  ["é"] = "e",
  ["è"] = "e",
  ["ë"] = "e",
  ["ê"] = "e",
  ["í"] = "i",
  ["ì"] = "i",
  ["ï"] = "i",
  ["î"] = "i",
  ["ó"] = "o",
  ["ò"] = "o",
  ["ö"] = "o",
  ["ô"] = "o",
  ["õ"] = "o",
  ["ú"] = "u",
  ["ù"] = "u",
  ["ü"] = "u",
  ["û"] = "u",
  ["ñ"] = "n",
  ["ç"] = "c",
  ["Á"] = "A",
  ["À"] = "A",
  ["Ä"] = "A",
  ["Â"] = "A",
  ["Ã"] = "A",
  ["Å"] = "A",
  ["É"] = "E",
  ["È"] = "E",
  ["Ë"] = "E",
  ["Ê"] = "E",
  ["Í"] = "I",
  ["Ì"] = "I",
  ["Ï"] = "I",
  ["Î"] = "I",
  ["Ó"] = "O",
  ["Ò"] = "O",
  ["Ö"] = "O",
  ["Ô"] = "O",
  ["Õ"] = "O",
  ["Ú"] = "U",
  ["Ù"] = "U",
  ["Ü"] = "U",
  ["Û"] = "U",
}

local M = {
  name = "Replace accents",
  key = "accent-replace",
  category = "wordlist",
  input_type = "toggle",
  default = false,
  db_ignore = false,
  order = 95,
  hooks = {
    on_load = function(words, is_active)
      if not is_active then return words end

      local fixed_words = {}

      for i, word in ipairs(words) do
        local new_word = word
        for accented, clean in pairs(accent_map) do
          new_word = new_word:gsub(accented, clean)
        end
        fixed_words[i] = new_word
      end

      return fixed_words
    end
  }
}

return M
