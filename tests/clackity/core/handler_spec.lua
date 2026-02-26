local assert = require("luassert.assert")
local handler = require("clackity.core.handler")
local state = require("clackity.core.state")
local ui = require("clackity.ui")

describe("Core Handler", function()
  before_each(function()
    state.reset()
    -- Mock UI to avoid headless errors
    ui.mark_correct = function() end
    ui.mark_error = function() end
    ui.move_cursor = function() end
  end)

  it("handles multi-line word wrapping and end-of-lesson", function()
    state.target_lines = { "a", "b" }

    -- Type 'a' (End of line 1)
    local finished_1 = handler.process_keystroke("a")
    assert.is_false(finished_1)
    assert.equals(1, state.current_row)
    assert.equals(0, state.current_col)

    -- Type 'b' (End of line 2 / End of lesson)
    local finished_2 = handler.process_keystroke("b")
    assert.is_true(finished_2)
  end)

  it("records timing latency in the stats log", function()
    state.target_lines = { "ab" }

    handler.process_keystroke("a")
    -- Simulate a 100ms delay
    vim.wait(100)
    handler.process_keystroke("b")

    local log = state.stats_log
    assert.equals(2, #log)
    assert.is_true(log[2].latency >= 0) -- Ensure timing is being captured
  end)
end)
