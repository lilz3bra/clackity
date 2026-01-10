vim.api.nvim_create_user_command("Clackity", function ()
    package.loaded["clackity"] = nil

    require("clackity").Start()
end, {})
