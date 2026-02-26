local assert = require("luassert.assert")
local accent_rule = require("clackity.rules.accent_transform")

describe("Rule: Accent Transform", function()
  it("removes accents when the rule is active", function()
    local input = { "árbol", "pingüino", "canción", }
    local expected = { "arbol", "pinguino", "cancion", }

    local result = accent_rule.hooks.on_load(input, true)

    assert.same(expected, result)
  end)

  it("returns the original array if the rule is inactive", function()
    local input = { "árbol", "pingüino" }

    local result = accent_rule.hooks.on_load(input, false)

    assert.same(input, result)
  end)
end)
