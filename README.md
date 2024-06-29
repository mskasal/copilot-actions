# nvim-custom-action

This Neovim plugin adds a custom action to the LSP code actions menu. When
selected, it adds a comment on top of the code block and replaces it.

## Installation

Use your preferred plugin manager to install.

Example with `packer.nvim`:

```lua
use {
    'path/to/nvim-custom-action',
    config = function()
        require('custom_action').register_custom_action()
    end,
    event = "BufRead",
}
```
