# ⌨️ clackity.nvim

![Neovim Version](https://img.shields.io/badge/Neovim-0.10+-blueviolet.svg)

Clackity is a fast, distraction-free typing practice plugin for Neovim. It is built to provide the best user experience possible.
It uses an "emulated" insert mode to make possible things like disabling fixing mistakes, stop on error, and possibly many more to come.

## ✨ Features

    Stats Tracking: Persists WPM and accuracy history using a local DB.

    Detailed stats: Track each keytroke, word, session, and see where your weak spots are.

    Useful graphs: Each stat can be viewed as a graph to help you understand your progress.

    The "Neovim Way": No complex menus—just simple, modal keymaps.

    Customizable: Make it to be whatever you want it to be.
    
    100% offline: Install and start typing, no need for an account.

## ⚡ Requirements

    Neovim >= 0.10.0
    kkharji/sqlite.lua installed in order to save the results

## 📦 Installation
lazy.nvim
```Lua
{
    "lilz3bra/clackity.nvim",
    dependencies = { "kkharji/sqlite.lua" }
    config = function()
        require("clackity").setup({})
    end,
}
```

packer.nvim
```Lua
use {
    "lilz3bra/clackity.nvim",
    requires = { 'kkharji/sqlite.lua' },
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

    [x] WPM / Accuracy Calculation implementation

    [x] Post lesson details

    [x] Results persistence

    [ ] Wordlists and list config

    [ ] Rules (some)
        [ ] Stop on error
        [ ] Fix errors
        [ ] Spacing errors
        [ ] Skip word

    [ ] Stats panel

    [ ] Stats graphs

    [ ] Per-key statistics

    [ ] Keyboard heatmap
    
    [ ] Database optimizations 

    [ ] Different layout/distribution support

    [ ] RPG mode (unlock keys by reaching a certain speed)

    [ ] More rules
    
    [ ] Wordlist rules (case, punctuation, etc)

    [ ] Wordlist generation and filtering

    [ ] More languages

    [ ] More wordlists (code snippets, quotes, etc)

    [ ] Custom rules

    [ ] Custom word lists 

## 🪲 Known bugs
- If the plugin crashes, cursor and keybindings will be messed up until neovim is restarted
- Backspace is not handled right now and messes (visually) with the cursor position

## 🤝 Contributing

For the time being I won't be accepting any PRs. 
This is a personal project and I want to keep it that way. Once I am satisfied with the plugin (or get bored) I will update this.

Enjoy typing! 🚀


