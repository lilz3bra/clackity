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
      vim.api.nvim_buf_del_keymap(bufnr, mode, key)
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

function M.attach_lesson(bufnr)
  -- TODO: add all the other keys
  -- TODO: add unused keys (like tab)
  smart_clear(bufnr, { "<CR>", "s", "q", "m", "r" })
  for i = 1, #keys do
    local char = keys:sub(i, i)
    vim.keymap.set("n", char, function()
      require("clackity.core").handle_input(char)
    end, { buffer = bufnr, nowait = true, noremap = true, silent = true })
  end

  -- Lesson control
  vim.keymap.set("n", "<C-q>", require("clackity.core").quit, { buffer = bufnr, silent = true })
  vim.keymap.set("n", "<C-r>", require("clackity.core").restart_lesson, { buffer = bufnr, silent = true })
  vim.keymap.set("n", "<Esc>", require("clackity.core").show_menu, { buffer = bufnr, silent = true })
end

function M.attach_main(bufnr)
  smart_clear(bufnr, keys)

  smart_clear(bufnr, { "<C-r>" })
  local opts = { buffer = bufnr, nowait = true, noremap = true, silent = true }

  vim.keymap.set("n", "<CR>", require("clackity.core").start_lesson, opts)
  -- vim.keymap.set("n", "s", require("clackity.core").show_stats, opts)
  vim.keymap.set("n", "q", require("clackity.core").quit, opts)
  vim.keymap.set("n", "<Esc>", require("clackity.core").quit, opts)
end

function M.attach_post_lesson(bufnr)
  smart_clear(bufnr, keys)
  smart_clear(bufnr, { "<CR>", "s", "<C-r", "<C-q>" })


  local opts = { buffer = bufnr, nowait = true, noremap = true, silent = true }

  vim.keymap.set("n", "r", require("clackity.core").restart_lesson, opts)
  vim.keymap.set("n", "q", require("clackity.core").quit, opts)
  vim.keymap.set("n", "m", require("clackity.core").show_menu, opts)
end

return M
