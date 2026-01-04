local builder = require('pest-nvim.builder')
local runner = require('pest-nvim.runner')
local buffer = require('pest-nvim.buffer')
local utils = require('pest-nvim.utils')

local M = {}

local config = {}

function M.run_file()
  local test_file = utils.get_current_test_file()
  if not test_file then
    vim.notify('Not in a Pest test file', vim.log.levels.ERROR)
    return
  end

  buffer.create_or_reuse_buffer(config)
  buffer.clear_buffer()

  local cmd = builder.build_command(config, { test_file = test_file })

  runner.run(cmd, function(data)
    buffer.append_to_buffer(data)
  end)
end

function M.run_test()
  local test_file = utils.get_current_test_file()
  if not test_file then
    vim.notify('Not in a Pest test file', vim.log.levels.ERROR)
    return
  end

  local test_method = utils.get_current_test_method()
  if not test_method then
    vim.notify('Cursor not in a test method', vim.log.levels.WARN)
    return
  end

  buffer.create_or_reuse_buffer(config)
  buffer.clear_buffer()

  local cmd = builder.build_command(config, {
    test_file = test_file,
    filter = test_method,
  })

  runner.run(cmd, function(data)
    buffer.append_to_buffer(data)
  end)
end

function M.run_all()
  buffer.create_or_reuse_buffer(config)
  buffer.clear_buffer()

  local cmd = builder.build_command(config, {})

  runner.run(cmd, function(data)
    buffer.append_to_buffer(data)
  end)
end

function M.run_filter(filter_string)
  if not filter_string or filter_string == '' then
    filter_string = vim.fn.input('Filter: ')
    if not filter_string or filter_string == '' then
      return
    end
  end

  buffer.create_or_reuse_buffer(config)
  buffer.clear_buffer()

  local cmd = builder.build_command(config, { filter = filter_string })

  runner.run(cmd, function(data)
    buffer.append_to_buffer(data)
  end)
end

function M.register(user_config)
  config = user_config

  vim.api.nvim_create_user_command('PestRunFile', M.run_file, {})
  vim.api.nvim_create_user_command('PestRunTest', M.run_test, {})
  vim.api.nvim_create_user_command('PestRunAll', M.run_all, {})
  vim.api.nvim_create_user_command('PestRunFilter', function(opts)
    M.run_filter(opts.args)
  end, { nargs = '?' })
end

return M
