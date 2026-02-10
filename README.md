# ⌨️ clackity.nvim

clackity.nvim is a fast, distraction-free typing practice plugin for Neovim. It is designed to be lightweight, using floating windows and native key bindings to provide a seamless "Neovim-native" experience.

## ✨ Features

    Stats Tracking: Persists WPM and accuracy history using a local DB.

    Detailed stats: Track each keytroke, word, session, and see where your weak spots are.

    Useful graphs: Each stat can be viewed as a graph to help you understand your progress.

    The "Neovim Way": No complex menus—just simple, modal keymaps.

    Configurable: Make it to be whatever you want it to be.

## ⚡ Requirements

    Neovim >= 0.9.0

## 📦 Installation
lazy.nvim
```Lua
{
    "lilz3bra/clackity.nvim",
    dependencies = {
        "kkharji/sqlite.lua", 
    },
    config = function()
        require("clackity").setup({})
    end,
}
```

packer.nvim
```Lua
use {
    "lilz3bra/clackity.nvim",
    requires = "kkharji/sqlite.lua",
    config = function()
        require("clackity").setup()
    end
}
```

## 🚀 Usage

Start the tutor by running the start command (or map it to a key):
```Vim Script

:lua require("clackity").Start()
```

(Recommended: Create a user command in your config)
```Lua

vim.api.nvim_create_user_command("Clackity", function()
    require("clackity").Start()
end, {})
```

## 🗺️ Roadmap

    [x] Basic typing logic

    [x] Menu Dashboard

    [x] Word wrapping & Layout engine

    [ ] WPM / Accuracy Calculation implementation

    [ ] Post lesson details

    [ ] Custom word lists (code snippets, prose)

    [ ] Ghost text (visualize cursor position better)

    [-] User configuration

    [ ] Custom rules

## 🪲 Known bugs
- If the plugin crashes, cursor and keybindings will be messed up
- Performance seems to be impacted for some reason (specially when saving)

## 🤝 Contributing

For the time being I won't be accepting any PRs. This is a personal project and I want to keep it that way. Once I am satisfied with the plugin (or get bored) I will update this.

Enjoy typing! 🚀


