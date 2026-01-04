# Development Guide

This guide explains how to develop and test pest.nvim locally.

## Local Development with Lazy.nvim

Add the plugin as a local path in your Neovim config:

```lua
{
  dir = '~/path/to/pest.nvim',
  config = function()
    require('pest-nvim').setup()
  end,
}
```

Replace `~/path/to/pest.nvim` with the actual path to your clone of the repository.

## Configuration for Development

You can use default settings or customize during development:

```lua
require('pest-nvim').setup({
  pest_cmd = 'vendor/bin/pest',
  window_size = 25,
})
```

## Reloading After Changes

### Quick Reload with Lazy.nvim

After making changes to the plugin, reload it using Lazy.nvim's built-in command:

```vim
:Lazy reload pest.nvim
```

This properly unloads all plugin modules and reloads them with your current changes.

**Development Tip:** Create a keymap for faster reloading during development:

```lua
vim.keymap.set('n', '<leader>Pr', ':Lazy reload pest.nvim<CR>', { desc = 'Reload pest.nvim' })
```

### Full Neovim Restart

If you encounter issues after reloading (especially after changing command definitions or plugin structure), restart Neovim completely:

```
:qa!
```

Then open Neovim again.

## Testing Development Changes

1. Make changes to plugin files in `lua/pest-nvim/`
2. Run the reload command above
3. Test using Pest commands:

   ```
   :PestRunFile
   :PestRunTest
   :PestRunAll
   :PestRunFilter
   ```

4. Verify output in the horizontal split window at bottom

## Project Structure

```
pest.nvim/
├── lua/
│   └── pest-nvim/
│       ├── init.lua       # Plugin entry point and config
│       ├── commands.lua   # Command definitions
│       ├── runner.lua     # Job execution
│       ├── buffer.lua     # Buffer/window management
│       ├── builder.lua     # Pest CLI builder
│       └── utils.lua      # Helper functions
├── plugin/
│   └── pest-nvim.lua    # Plugin loader
└── README.md
```

## Common Development Tasks

### Adding a New Command

1. Add command function in `lua/pest-nvim/commands.lua`
2. Register it in `M.register()` function
3. Reload plugin to test

### Modifying Test Detection

Edit `lua/pest-nvim/utils.lua`:

- `is_test_file()` - File pattern matching
- `get_current_test_method()` - Test method detection

### Changing Buffer Behavior

Edit `lua/pest-nvim/buffer.lua`:

- `create_or_reuse_buffer()` - Window creation
- `append_to_buffer()` - Output handling
- `clear_buffer()` - Buffer clearing

## Debugging

Enable verbose logging to debug issues:

```lua
:lua print(vim.inspect(require('pest-nvim').config))
```

Check the result window for Pest output and error messages.
