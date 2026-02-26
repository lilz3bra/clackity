local assert = require("luassert.assert")
local rules = require("clackity.rules")

describe("Rules Pipeline Engine", function()
  before_each(function()
    rules.registry = {}
    rules.active_hooks = { on_load = {} }
  end)

  it("resolves and sorts active hooks by priority order", function()
    rules.registry["late_rule"] = {
      name = "Late",
      key = "late_rule",
      category = "test",
      input_type = "toggle",
      default = true,
      order = 90,
      hooks = {
        on_load = function(w)
          table.insert(w, "late"); return w
        end
      }
    }
    rules.registry["early_rule"] = {
      name = "Early",
      key = "early_rule",
      category = "test",
      input_type = "toggle",
      default = true,
      order = 10,
      hooks = {
        on_load = function(w)
          table.insert(w, "early"); return w
        end
      }
    }

    local mock_session = { late_rule = true, early_rule = true }

    rules.resolve_active_hooks(mock_session)
    local result = rules.run_load_hooks({})

    assert.equals(2, #result)
    assert.equals("early", result[1])
    assert.equals("late", result[2])
  end)

  it("safely ignores rules that do not return a table", function()
    rules.registry["broken_rule"] = {
      name = "Broken",
      key = "broken_rule",
      category = "test",
      input_type = "toggle",
      default = true,
      order = 50,
      hooks = { on_load = function(w) return nil end }
    }
    rules.registry["good_rule"] = {
      name = "Good",
      key = "good_rule",
      category = "test",
      input_type = "toggle",
      default = true,
      order = 60,
      hooks = {
        on_load = function(w)
          table.insert(w, "good"); return w
        end
      }
    }

    local mock_session = { broken_rule = true, good_rule = true }

    rules.resolve_active_hooks(mock_session)
    local result = rules.run_load_hooks({})

    assert.equals(1, #result)
    assert.equals("good", result[1])
  end)
end)
