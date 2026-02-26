local assert = require("luassert.assert")
local core = require("clackity.core")
local state = require("clackity.core.state")
local config = require("clackity.core.config")
local db = require("clackity.database")

describe("Core Orchestrator", function()
  before_each(function()
    -- Fully boot the backend before simulating a user
    config.setup({})
    db.init()
    state.reset()
  end)

  after_each(function()
    db.close()
    collectgarbage("collect")
  end)

  it("navigates the full lifecycle without hanging", function()
    -- 1. Pre-load the 'typeahead' buffer:
    -- 'o' to open options, 'q' to go back, 'Enter' to start, 'Ctrl+C' to kill loop
    vim.api.nvim_input("o q <CR> \3")

    -- 2. Start the plugin
    core.start_plugin()

    -- 3. Manually trigger the navigation paths
    -- This hits the lines in core/init.lua that were 'Missed'
    core.show_config_menu()
    core.show_menu()

    -- 4. Mock a finished state so post_lesson doesn't crash on empty stats
    local state = require("clackity.core.state")
    state.stats_log = {
      { target = "a", actual = "a", latency = 10, status = "correct" }
    }

    core.post_lesson()

    -- 5. Final cleanup
    core.quit()

    -- Give Neovim a moment to flush the input queue
    vim.wait(100)
  end)
  it("starts the plugin, initializes state, and draws the menu", function()
    core.start_plugin()

    assert.truthy(state.bufnr)
    assert.truthy(state.win_id)
    assert.is_true(vim.api.nvim_buf_is_valid(state.bufnr))

    -- Read the screen to ensure we landed on the Main Menu
    local lines = vim.api.nvim_buf_get_lines(state.bufnr, 0, -1, false)
    assert.equals("   CLACKITY ", lines[2])

    core.quit()
  end)

  it("generates the configuration menu dynamically", function()
    core.start_plugin()
    core.show_config_menu()

    -- Read the screen to ensure we navigated to the Config Menu
    local lines = vim.api.nvim_buf_get_lines(state.bufnr, 0, -1, false)
    assert.equals("   CONFIGURATION", lines[2])

    core.quit()
  end)

  it("starts a lesson and populates the target lines", function()
    core.start_plugin()
    core.start_lesson()

    -- Verify the engine successfully loaded and wrapped the wordlist
    assert.is_true(#state.target_lines > 0)

    vim.api.nvim_input("\3")
    core.quit()
  end)
end)
