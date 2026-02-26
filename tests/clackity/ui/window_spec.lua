local assert = require("luassert.assert")
local window = require("clackity.ui.window")

describe("UI Window", function()
  it("creates a valid floating window and buffer", function()
    local obj = window.create_window()

    assert.truthy(obj.buf)
    assert.truthy(obj.win)
    assert.is_true(vim.api.nvim_buf_is_valid(obj.buf))
    assert.is_true(vim.api.nvim_win_is_valid(obj.win))

    -- Clean up the window so it doesn't pollute other tests
    vim.api.nvim_win_close(obj.win, true)
  end)

  it("sets up buffer key timeout fixes without crashing", function()
    local buf = vim.api.nvim_create_buf(false, true)

    -- We just want to ensure the autocmds are created without throwing Neovim API errors
    local ok = pcall(window.buffer_keys_fix, buf)
    assert.is_true(ok)
  end)

  it("safely swaps and restores the cursor", function()
    -- Capture the actual current state
    local orig_cursor = vim.opt.guicursor:get()

    -- Swap to the fake cursor and verify it returned the correct original state
    local captured_orig = window.set_fake_cursor()
    assert.same(orig_cursor, captured_orig)

    -- Restore it and verify the global option actually reverted
    window.restore_cursor()
    assert.same(orig_cursor, vim.opt.guicursor:get())
  end)
end)
