local M = {}

--- @type string[]
local wordlist = {
  "the",
  "quick",
  "brown",
  "fox",
  "jumped",
  "over",
  "lazy",
  "dog",
  "the",
  "and",
  "have",
  "that",
  "for",
  "you",
  "with",
  "say",
  "this",
  "they",
  "but",
  "his",
  "from",
  "not",
  "she",
  "as",
  "what",
  "their",
  "can",
  "who",
  "get",
  "would",
  "her",
  "all",
  "make",
  "about",
  "know",
  "will",
  "one",
  "time",
  "there",
  "year",
  "think",
  "when",
  "which",
  "them",
  "some",
  "people",
  "take",
  "out",
  "into",
  "just",
  "see",
  "him",
  "your",
  "come",
  "could",
  "now",
  "than",
  "like",
  "other",
  "how",
  "then",
  "its",
  "our",
  "two",
  "more",
  "these",
  "want",
  "way",
  "look",
  "first",
  "also",
  "new",
  "because",
  "day",
  "use",
  "man",
  "find",
  "here",
  "thing",
  "give",
  "many",
  "well",
  "only",
  "those",
  "tell",
  "very",
  "even",
  "back",
  "any",
  "good",
  "woman",
  "through",
  "life",
  "child",
  "work",
  "down",
  "may",
  "after",
  "should",
  "call",
  "world",
  "over",
  "school",
  "still",
  "try",
  "last",
  "ask",
  "need",
  "too",
  "feel",
  "three",
  "state",
  "never",
  "become",
  "between",
  "high",
  "really",
  "something",
  "most",
  "another",
  "much",
  "family",
  "own",
  "leave",
  "put",
  "old",
  "while",
  "mean",
  "keep",
  "student",
  "why",
  "let",
  "great",
  "same",
  "big",
  "group",
  "begin",
  "seem",
  "country",
  "help",
  "talk",
  "where",
  "turn",
  "problem",
  "every",
  "start",
  "hand",
  "might",
  "American",
  "show",
  "part",
  "against",
  "place",
  "such",
  "again",
  "few",
  "case",
  "week",
  "company",
  "system",
  "each",
  "right",
  "program",
  "hear",
  "question",
  "during",
  "play",
  "government",
  "run",
  "small",
  "number",
  "off",
  "always",
  "move",
  "night",
  "live",
  "Mr",
  "point",
  "believe",
  "hold",
  "today",
  "bring",
  "happen",
  "next",
  "without",
  "before",
  "large",
  "million",
  "must",
  "home",
  "under",
  "water",
  "room",
  "write",
  "mother",
  "area",
  "national",
  "money",
  "story",
  "young",
  "fact",
  "month",
  "different",
  "lot",
  "study",
  "book",
  "eye",
  "job",
  "word",
  "though",
  "business",
  "issue",
  "side",
  "kind",
  "four",
  "head",
  "far"
}

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
