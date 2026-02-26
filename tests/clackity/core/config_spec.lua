local assert = require("luassert.assert")
local config = require("clackity.core.config")

describe("Config Manager", function()
  local test_json = vim.fn.stdpath("data") .. "/clackity.json"

  before_each(function()
    -- Ensure a completely clean slate before every test
    os.remove(test_json)
    config.session_rules = { rules = {} }
  end)

  after_each(function()
    -- Clean up the dummy file after the tests finish
    os.remove(test_json)
  end)

  it("sets up defaults and merges user options", function()
    config.setup({ custom_user_opt = "override" })

    assert.equals("override", config.user_settings.custom_user_opt)
    -- The rule registry defaults should be automatically loaded
    assert.is_not_nil(config.session_rules.rules["word_count"])
  end)

  it("saves a rule and persists it to a JSON file", function()
    config.setup()
    config.save_rule("word_count", 999)

    assert.equals(999, config.session_rules.rules["word_count"])

    -- Verify it physically wrote to the disk
    local f = io.open(test_json, "r")
    assert.is_not_nil(f, "JSON file should exist")
    local content = f:read("*a")
    f:close()

    assert.truthy(string.find(content, "999"))
  end)

  it("notifies the user if config file is not writable", function()
    local original_io_open = io.open
    -- Mock io.open to fail only for write mode
    io.open = function(path, mode)
      if mode == "w" then return nil end
      return original_io_open(path, mode)
    end

    local ok = pcall(function()
      config.save_rule("any_key", "any_value")
    end)

    assert.is_true(ok) -- Ensure it doesn't crash, just notifies
    io.open = original_io_open
  end)
  it("extracts active rules while omitting defaults and ignored fields", function()
    config.setup()
    -- Modify one rule away from its default
    config.save_rule("word_count", 777)

    local active = config.get_active_rules()

    -- It should extract our customized rule
    assert.equals(777, active["word_count"])

    -- But it should omit the wordlist rule because db_ignore = true in its registry blueprint
    assert.is_nil(active["wordlist"])
  end)
end)
