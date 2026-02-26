local assert = require("luassert.assert")
local word_count = require("clackity.rules.word_count")

describe("Rule: Word Count", function()
  it("returns the exact number of requested words", function()
    local input = { "apple", "banana", "cherry", "date", "elderberry" }
    local result = word_count.hooks.on_load(input, 3)

    assert.equals(3, #result)
  end)

  it("returns all available words if request exceeds array size", function()
    local input = { "apple", "banana" }
    local result = word_count.hooks.on_load(input, 10)

    assert.equals(2, #result)
  end)

  it("returns an empty table if the input is empty", function()
    local result = word_count.hooks.on_load({}, 5)

    assert.same({}, result)
  end)
end)
