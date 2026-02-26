local luarocks_path = vim.fn.expand("~/.luarocks/share/lua/5.1/?.lua;") ..
    vim.fn.expand("~/.luarocks/share/lua/5.1/?/init.lua;")
local luarocks_cpath = vim.fn.expand("~/.luarocks/lib/lua/5.1/?.so;")

package.path = package.path .. ";" .. luarocks_path
package.cpath = package.cpath .. ";" .. luarocks_cpath

local has_luacov, runner = pcall(require, "luacov.runner")
if has_luacov then
  runner.init()
  -- Plenary exits abruptly. This forces LuaCov to write the stats file first.
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      runner.shutdown()
    end
  })
else
  print("\n[Clackity] WARNING: luacov not found. Coverage will not be generated.\n")
end

local root = vim.fn.fnamemodify("./.tests/", ":p")

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
vim.env.SQLITE_DB_PATH = ""
