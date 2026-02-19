local root = vim.fn.fnamemodify("./.tests", ":p")

local function load_plugin(repo, name)
  local dir = root .. name
  if vim.fn.isdirectory(dir) == 0 then
    print("\n[Clackity] Installing " .. name .. " for tests...\n")
    vim.fn.system({
      "git",
      "clone",
      "--depth=1",
      "https://github.com/" .. repo,
      dir
    })
  end
  vim.opt.rtp:prepend(dir)
end

load_plugin("nvim-lua/plenary.nvim", "plenary.nvim")
load_plugin("kkharji/sqlite.lua", "sqlite.lua")

vim.opt.rtp:prepend(".")

vim.cmd("runtime! plugin/plenary.vim")

vim.env.SQLITE_DB_PATH = ":memory:"
