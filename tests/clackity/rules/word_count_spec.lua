local assert = require("luassert.assert")
local word_count = require("clackity.rules.word_count")

describe("Rule: Word Count", function()
  it("returns the exact number of requested words", function()
    local input = { "apple", "banana", "cherry", "date", "elderberry" }
    local result = word_count.hooks.on_load(input, 3)

    assert.equals(3, #result)
  end)

  it("returns repeated words if request exceeds array size", function()
    local input = { "yay", "nay" }
    local count = 5
    local result = word_count.hooks.on_load(input, count)

    -- It should return exactly 5 words, even though we only gave it 2
    assert.equals(5, #result)

    -- Verify all returned words actually exist in the input list
    for _, word in ipairs(result) do
      local found = false
      for _, input_word in ipairs(input) do
        if word == input_word then found = true end
      end
      assert.is_true(found)
    end
  end)

  it("returns an empty table if the input is empty", function()
    local result = word_count.hooks.on_load({}, 5)

    assert.same({}, result)
  end)
end)
