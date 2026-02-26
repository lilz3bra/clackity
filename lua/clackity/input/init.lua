local M = {}

local keys = "abcdefghijklmnopqrstuvwxyz "


--- Safely removes keymaps only if they currently exist in the buffer
--- @param bufnr number
--- @param keys_to_check string[]|string -- Table of keys or string of chars
local function smart_clear(bufnr, keys_to_check)
  local mode = "n"
  local existing_maps = vim.api.nvim_buf_get_keymap(bufnr, mode)
  local map_set = {}

  for _, map in ipairs(existing_maps) do
    map_set[map.lhs] = true
  end

  local function unmap_if_exists(key)
    if map_set[key] then
      pcall(function() vim.api.nvim_buf_del_keymap(bufnr, mode, key) end)
    end
  end

  if type(keys_to_check) == "table" then
    for _, key in ipairs(keys_to_check) do
      unmap_if_exists(key)
    end
  elseif type(keys_to_check) == "string" then
    for i = 1, #keys_to_check do
      unmap_if_exists(keys_to_check:sub(i, i))
    end
  end
end

--- @param bufnr number
--- @param actions Clackity.UI.LessonActions
function M.attach_lesson(bufnr, actions)
  smart_clear(bufnr, { "<CR>", "s", "q", "m", "r" })

  vim.schedule(function()
    M.typing_loop(actions)
  end)
end

--- @param actions Clackity.UI.LessonActions
function M.typing_loop(actions)
  vim.cmd("redraw")

  while true do
    local ok, char = pcall(vim.fn.getcharstr)

    -- Ctrl+C or process killed
    if not ok or char == "\3" then
      actions.on_quit()
      break
    end

    -- Esc (\27)
    if char == "\27" or char == "\17" then
      actions.on_menu()
      break
    end

    -- Ctrl+R (\18)
    if char == "\18" then
      actions.on_restart()
      break
    end

    -- Pass the raw character to whatever callback was injected
    local is_finished = actions.on_keystroke(char)

    vim.cmd("redraw")

    if is_finished then
      break
    end
  end
end

--- @param bufnr number
function M.attach_main(bufnr)
  smart_clear(bufnr, keys)

  smart_clear(bufnr, { "<C-r>" })
  local opts = { buffer = bufnr, nowait = true, noremap = true, silent = true }

  vim.keymap.set("n", "<CR>", require("clackity.core").start_lesson, opts)
  -- vim.keymap.set("n", "s", require("clackity.core").show_stats, opts)
  vim.keymap.set("n", "q", require("clackity.core").quit, opts)
  vim.keymap.set("n", "<Esc>", require("clackity.core").quit, opts)
  vim.keymap.set("n", "o", require("clackity.core").show_config_menu, opts)
end

--- @param bufnr number
function M.attach_post_lesson(bufnr)
  smart_clear(bufnr, keys)
  smart_clear(bufnr, { "<CR>", "s", "<C-r", "<C-q>" })


  local opts = { buffer = bufnr, nowait = true, noremap = true, silent = true }

  vim.keymap.set("n", "r", require("clackity.core").start_lesson, opts)
  vim.keymap.set("n", "q", require("clackity.core").quit, opts)
  vim.keymap.set("n", "m", require("clackity.core").show_menu, opts)
end

--- Reusable input handler for ANY menu that needs j/k/Enter navigation
--- @param bufnr number
--- @param actions Clackity.UI.SelectorActions Contains down, up, select, and back closures
function M.attach_selector(bufnr, actions)
  smart_clear(bufnr, keys)
  smart_clear(bufnr, { "<CR>", "<Esc>", "q" })

  local opts = { buffer = bufnr, nowait = true, noremap = true, silent = true }

  -- Only map the triggers. Navigation is native!
  vim.keymap.set("n", "<CR>", actions.select, opts)
  vim.keymap.set("n", "<Esc>", actions.back, opts)
  vim.keymap.set("n", "q", actions.back, opts)
end

return M
