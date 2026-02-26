local assert = require("luassert.assert")
local ui = require("clackity.ui")

describe("UI Engine", function()
  local test_buf

  before_each(function()
    -- Create a scratch buffer before each test
    test_buf = vim.api.nvim_create_buf(false, true)
    -- Initialize the highlight namespaces so the paint functions don't crash
    require("clackity.ui.highlight").setup()
  end)

  it("creates a floating window and buffer natively", function()
    local obj = ui.create_window()

    assert.truthy(obj.buf)
    assert.truthy(obj.win)
    assert.is_true(vim.api.nvim_buf_is_valid(obj.buf))
    assert.is_true(vim.api.nvim_win_is_valid(obj.win))

    ui.close(obj.win)
  end)

  it("renders text to a buffer and locks it", function()
    ui.render_main(test_buf, { "hello", "world" })
    local lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)

    assert.same({ "hello", "world" }, lines)
    -- Verify the UI strictly prevents user tampering (modifiable = false)
    assert.is_false(vim.api.nvim_get_option_value("modifiable", { buf = test_buf }))
  end)

  it("draws the main menu correctly", function()
    ui.draw_menu(test_buf)
    local lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)

    assert.equals("   CLACKITY ", lines[2])
  end)

  it("applies highlight markers without crashing", function()
    ui.render_lines(test_buf, { "test line" })

    -- If these extmark API calls are typed incorrectly, this test will explode
    ui.mark_correct(test_buf, 0, 0, 4)
    ui.mark_error(test_buf, 0, 5, 9)
  end)
end)
