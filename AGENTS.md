# Project: pest.nvim

Neovim plugin for running PHP Pest tests with streaming output.

## Structure

- `lua/pest-nvim/` - Main plugin modules
  - `init.lua` - Entry point, config
  - `commands.lua` - User commands (`:PestRunFile`, `:PestRunTest`, etc.)
  - `runner.lua` - Async job execution via `vim.fn.jobstart()`
  - `buffer.lua` - Result window management (horizontal split at bottom, 25% height)
  - `builder.lua` - Pest CLI command builder
  - `utils.lua` - Test file/method detection
- `plugin/pest-nvim.lua` - Plugin loader for Neovim

## Tech Stack

- Lua (Neovim 0.7+)
- Zero external dependencies
- PHP Pest testing framework integration

## Conventions

- Use `vim.fn.jobstart()` for async jobs (not plenary.nvim)
- Result buffer: horizontal split at bottom, read-only, modifiable=false
- Test detection: files matching `*Test.php` or `test_*.php`
- Test methods: Pest syntax (`it('desc', ...)`, `test('desc', ...)`)
- Config: merge user config with defaults using `vim.tbl_extend('force', ...)`
- No default keybindings - document examples in README only

## Pest Test Format

```php
it('test description', function () {
    // test code
});

test('test description', function () {
    // test code
});
```
