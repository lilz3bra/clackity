local assert = require("luassert.assert")
local input = require("clackity.input")

describe("Input Engine", function()
  local test_buf

  before_each(function()
    test_buf = vim.api.nvim_create_buf(false, true)
  end)


  it("attaches main menu keybindings correctly", function()
    input.attach_main(test_buf)
    local maps = vim.api.nvim_buf_get_keymap(test_buf, "n")

    local mapped_keys = {}
    for _, map in ipairs(maps) do
      mapped_keys[map.lhs] = true
    end

    -- Verify the critical bindings were set
    assert.is_true(mapped_keys["<CR>"])
    assert.is_true(mapped_keys["q"])
    assert.is_true(mapped_keys["o"])
  end)

  it("attaches selector keybindings correctly", function()
    input.attach_selector(test_buf, { select = function() end, back = function() end })
    local maps = vim.api.nvim_buf_get_keymap(test_buf, "n")

    local mapped_keys = {}
    for _, map in ipairs(maps) do
      mapped_keys[map.lhs] = true
    end

    assert.is_true(mapped_keys["<CR>"])
    assert.is_true(mapped_keys["<Esc>"])
    assert.is_true(mapped_keys["q"])
  end)
  it("handles the typing loop safely and intercepts keys", function()
    local typed_chars = {}
    local quit_called = false

    -- Instead of nvim_input, we use a timer to fire the keys
    -- 10ms after the loop starts.
    local timer = vim.uv.new_timer()
    timer:start(10, 0, vim.schedule_wrap(function()
      -- Feed 'a' then 'Ctrl+C'
      vim.api.nvim_feedkeys("a\3", "nt", false)
    end))

    input.typing_loop({
      on_quit = function() quit_called = true end,
      on_menu = function() end,
      on_restart = function() end,
      on_retry = function() end,
      on_keystroke = function(c)
        table.insert(typed_chars, c)
        return false
      end
    })

    timer:stop()
    timer:close()

    assert.equals(1, #typed_chars)
    assert.equals("a", typed_chars[1])
    assert.is_true(quit_called)
  end)
end)
