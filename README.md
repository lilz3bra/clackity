# ⌨️ clackity.nvim

A minimalist typing tutor that lives inside your editor.

clackity.nvim is a fast, distraction-free typing practice plugin for Neovim. It is designed to be lightweight, using floating windows and native key bindings to provide a seamless "Neovim-native" experience.

## ✨ Features

    Stats Tracking: Persists WPM and accuracy history using a local DB.

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

    [-] Word wrapping & Layout engine

    [ ] WPM / Accuracy Calculation implementation

    [ ] Custom word lists (code snippets, prose)

    [ ] Ghost text (visualize cursor position better)

    [ ] User configuration

    [ ] Custom rules

## 🪲 Known bugs
- If the plugin crashes, cursor and keybindings will be messed up
- Performance seems to be impacted for some reason (specially when saving)

## 🤝 Contributing

Pull requests are welcome! Please ensure that any logic changes maintain the "modal" philosophy of the plugin (avoiding nvim-ui-select menus in favor of keymaps).

    Fork the repo

    Create your feature branch (git checkout -b feature/amazing-feature)

    Commit your changes (git commit -m 'Add some amazing feature')

    Push to the branch (git push origin feature/amazing-feature)

    Open a Pull Request

Enjoy typing! 🚀


