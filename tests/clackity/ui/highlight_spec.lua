local assert = require("luassert.assert")
local highlight = require("clackity.ui.highlight")

describe("UI Highlight", function()
  local test_buf

  before_each(function()
    test_buf = vim.api.nvim_create_buf(false, true)
    -- Insert a dummy line so we have byte-indexes to highlight
    vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, { "hello world" })
  end)

  it("sets up the highlight groups cleanly", function()
    local ok = pcall(highlight.setup)
    assert.is_true(ok)
  end)

  it("paints text ranges and lines without API errors", function()
    highlight.setup()

    -- If you change the API signature later, these pcalls will catch the crash
    local ok_paint = pcall(highlight.paint, test_buf, "ClackityCorrect", 0, 0, 4)
    assert.is_true(ok_paint)

    local ok_line = pcall(highlight.paint_line, test_buf, "ClackitySelection", 0)
    assert.is_true(ok_line)
  end)

  it("clears the namespace", function()
    local ok = pcall(highlight.clear, test_buf)
    assert.is_true(ok)
  end)
end)
