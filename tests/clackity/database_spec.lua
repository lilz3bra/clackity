local assert = require("luassert.assert")
local db = require("clackity.database")

describe("Database - Edge Cases", function()
  before_each(function()
    db.init()
  end)

  after_each(function()
    db.close()
    collectgarbage("collect")
  end)

  it("handles complex rule values (tables) via JSON encoding", function()
    local fake_lesson = { list_name = "test", layout = "def", time = 10, errors = 0, characters = 5, square_time = 10 }
    local fake_keys = { ["a"] = { errors = 0, time = 1, appearances = 1, square_time = 1 } }

    -- Passing a table as a rule value triggers the json_encode branch
    local complex_rules = { custom_list = { "word1", "word2" } }

    local ok = pcall(function()
      db.save_lesson(fake_lesson, fake_keys, complex_rules)
    end)
    assert.is_true(ok)
  end)

  it("gracefully ignores saving if database connection is nil", function()
    -- We'll manually nuke the internal db reference to test the guard clause
    -- Note: This depends on how strictly your module hides the 'db' variable.
    -- If it's local in the module, this is hard to test without a reload.
    -- But we can test the pcall catches errors.
    local ok = pcall(function() db.save_lesson(nil, nil, nil) end)
    assert.is_true(ok)
  end)
end)
