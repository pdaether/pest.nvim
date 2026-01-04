# pest.nvim

A Neovim plugin for running PHP Pest tests directly from your editor with real-time streaming output.

## Features

- Run individual test files, single tests, all tests, or filtered tests
- Results display in a dedicated horizontal split buffer
- Streaming output for real-time feedback
- Simple, zero-dependency Lua implementation

## Requirements

- Neovim 0.7 or higher
- PHP Pest testing framework installed in your project

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'pdaether/pest.nvim'
lua require('pest-nvim').setup()
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'pdaether/pest.nvim',
  config = function()
    require('pest-nvim').setup()
  end
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'pdaether/pest.nvim',
  config = function()
    require('pest-nvim').setup()
  end
}
```

## Configuration

The plugin can be configured with custom settings:

```lua
require('pest-nvim').setup({
  pest_cmd = 'vendor/bin/pest',  -- Path to Pest executable
  window_size = 25,               -- Result window height as percentage of screen
})
```

### Configuration Options

- `pest_cmd` (string): Path to the Pest CLI executable. Default: `'vendor/bin/pest'`
- `window_size` (number): Height of the result window as percentage of screen height. Default: `25`

## Usage

The plugin provides four commands for running tests:

### Commands

- `:PestRunAll` - Run all tests in the project
- `:PestRunFilter [filter]` - Run tests matching a filter pattern
- `:PestRunFile` - Run tests in the current file
- `:PestRunTest` - Run the test method at the current cursor position

### Example Usage

Run tests in the current test file:

```
:PestRunFile
```

Run the test at your cursor position:

```
:PestRunTest
```

Run all tests:

```
:PestRunAll
```

Run tests matching a filter:

```
:PestRunFilter login
```

Or provide the filter interactively:

```
:PestRunFilter
```

## Test Detection

The plugin automatically detects:

- **Test files**: Files matching patterns like `UserTest.php`
- **Test methods**: Pest test definitions using `it()`, `test()`, or `todo()` functions

When using `:PestRunTest`, the plugin will search upwards from the cursor to find the nearest test method. If no test method is found, a warning is displayed.

**Example Pest test syntax:**

```php
it('can login user', function () {
    // test code
});

test('user can login', function () {
    // test code
});
```

## Keybindings

The plugin defines the following default keybindings:

- `<leader>Pa` - Run all tests
- `<leader>Pf` - Run current test file
- `<leader>Pt` - Run test under cursor
- `<leader>Ps` - Run filtered tests (prompts for filter)

### Customizing Keybindings

If you prefer different keybindings, you can override the defaults by adding your own mappings after the plugin setup in your Neovim configuration:

```lua
require('pest-nvim').setup()

-- Override with your custom keybindings
vim.api.nvim_set_keymap('n', '<leader>pf', ':PestRunFile<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pt', ':PestRunTest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pa', ':PestRunAll<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ps', ':PestRunFilter ', { noremap = true })
```

### Which-Key Integration (LazyVim)

If you're using LazyVim or have which-key.nvim installed, you can set a proper group name for the Pest keybindings by adding this to your configuration:

```lua
-- For LazyVim users, add this to your config
require('which-key').add({
  { "<leader>P", group = "Pest" }
})
```

Or if using the legacy which-key API:

```lua
require('which-key').register({
  P = { name = "Pest" }
}, { prefix = "<leader>" })
```

This will display "Pest" instead of "+4 keymaps" when you press `<leader>` in normal mode.

## Result Window

Test results are displayed in a horizontal split window at the bottom of the screen. The window:

- Opens automatically when a test command is run
- Streams output in real-time as tests run
- Closes automatically before a new test run (window reuse)
- Is read-only but allows text copying

## Troubleshooting

### Pest command not found

If you get an error that Pest is not found, ensure:

1. Pest is installed in your project (`vendor/bin/pest`)
2. You're running the command from your project root
3. Update the `pest_cmd` configuration if using a custom path

### Test file not detected

The plugin looks for files matching these patterns:

- Files ending with `Test.php` (e.g., `UserTest.php`)

Ensure your test files follow this convention.

### Test method not detected

The plugin searches for `it()`, `test()` function definitions. If your cursor is not inside a test method, `:PestRunTest` will display a warning.

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
