local assert = require("luassert.assert")
local wordlist = require("clackity.wordlist")

describe("Wordlist Engine", function()
  describe("wrap_words", function()
    it("packs words onto a single line if they fit within max_width", function()
      local input = { "one", "two", "three" }
      -- "one two three" is 13 characters
      local result = wordlist.wrap_words(input, 20)

      assert.equals(1, #result)
      assert.equals("one two three", result[1])
    end)

    it("wraps to the next line when max_width is exceeded", function()
      local input = { "this", "is", "a", "test", "string" }
      -- max_width 10 should break "this is a" (9) and put "test string" (11) on the next
      local result = wordlist.wrap_words(input, 12)
      assert.equals(2, #result)
      assert.equals("this is a ", result[1])
      assert.equals("test string", result[2])
    end)

    it("returns an empty table if given an empty wordlist", function()
      local result = wordlist.wrap_words({}, 50)
      assert.same({}, result)
    end)
    it("handles missing wordlists gracefully", function()
      -- Mock Neovim to return no matches for a fake wordlist
      local original_get_runtime = vim.api.nvim_get_runtime_file
      vim.api.nvim_get_runtime_file = function() return {} end

      -- This should trigger the vim.notify error path
      local result = wordlist.load_wordlist("non_existent")

      assert.same({}, result)

      -- Restore original
      vim.api.nvim_get_runtime_file = original_get_runtime
    end)

    it("handles empty or unreadable files gracefully", function()
      -- Mock io.open to return nil (simulating a permissions error or missing file)
      local original_io_open = io.open
      io.open = function() return nil end

      local result = wordlist.load_wordlist("error_file")
      assert.same({}, result)

      io.open = original_io_open
    end)
  end)
end)
