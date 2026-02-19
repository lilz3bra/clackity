local stats = require("clackity.stats")
local assert = require("luassert.assert")

describe("Clackity Stats", function()
  it("calculates 100% accuracy and perfect WPM", function()
    local fake_log = {
      { target = "h", actual = "h", latency = 0,   status = "correct" },
      { target = "e", actual = "e", latency = 120, status = "correct" },
      { target = "l", actual = "l", latency = 120, status = "correct" },
      { target = "l", actual = "l", latency = 120, status = "correct" },
      { target = "h", actual = "o", latency = 120, status = "correct" },
    }
    local result = stats.lesson_stats(fake_log)

    assert.equals(100, result.accuracy)
    assert.equals(125, result.wpm)
    assert.equals(480, result.time)
    assert.equals(5, result.total_chars)
    assert.equals(0, result.errors)
  end)

  it("calculates accuracy correctly with errors", function()
    local fake_log = {
      { target = "c", actual = "c", latency = 0,   status = "correct" },
      { target = "a", actual = "x", latency = 120, status = "error" },
      { target = "t", actual = "t", latency = 120, status = "correct" },
      { target = "s", actual = "s", latency = 120, status = "correct" },
    }
    local result = stats.lesson_stats(fake_log)

    assert.equals(75, result.accuracy)
    assert.equals(1, result.errors)
  end)

  it("calculates terfect consistency when rhytm is identical", function()
    local fake_log = {
      { target = "a", actual = "a", latency = 0,   status = "correct" },
      { target = "b", actual = "b", latency = 120, status = "correct" },
      { target = "c", actual = "c", latency = 120, status = "correct" },
      { target = "d", actual = "d", latency = 120, status = "correct" },
    }
    local result = stats.lesson_stats(fake_log)

    assert.equals(100, result.consistency)
  end)
end
)
