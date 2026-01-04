local M = {}

function M.build_command(config, options)
  local cmd = { config.pest_cmd }

  if options.filter then
    table.insert(cmd, '--filter=' .. options.filter)
  end

  if options.test_file then
    table.insert(cmd, options.test_file)
  end

  return cmd
end

return M
