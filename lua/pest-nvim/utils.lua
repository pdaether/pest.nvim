local M = {}

function M.is_test_file(filepath)
  if not filepath then
    return false
  end

  local filename = vim.fn.fnamemodify(filepath, ':t')
  return filename:match('Test%.php$') ~= nil or filename:match('^test_') ~= nil
end

function M.get_current_test_file()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == '' then
    return nil
  end

  if M.is_test_file(filepath) then
    return filepath
  end

  return nil
end

-- Try to use Treesitter for accurate test detection
local function get_test_method_treesitter()
  local ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
  if not ok then
    return nil
  end

  local node = ts_utils.get_node_at_cursor()
  if not node then
    return nil
  end

  -- Traverse up the tree to find a function call node
  while node do
    if node:type() == 'function_call_expression' then
      -- Check if the function name is 'it' or 'test'
      local name_node = node:named_child(0)
      if name_node and name_node:type() == 'name' then
        local func_name = vim.treesitter.get_node_text(name_node, 0)
        if func_name == 'it' or func_name == 'test' then
          -- Get the first argument (the test description)
          local args_node = node:named_child(1)
          if args_node and args_node:type() == 'arguments' then
            local first_arg = args_node:named_child(0)
            if first_arg and (first_arg:type() == 'string' or first_arg:type() == 'encapsed_string') then
              local test_desc = vim.treesitter.get_node_text(first_arg, 0)
              -- Remove quotes from the string
              test_desc = test_desc:match('^["\'](.+)["\']$') or test_desc
              return test_desc
            end
          end
        end
      end
    end
    node = node:parent()
  end

  return nil
end

-- Fallback to regex-based detection
local function get_test_method_regex()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  local test_name = nil
  local test_start_line = nil
  local brace_count = 0
  local in_test = false

  -- Search backwards from cursor to find the test definition
  for i = cursor_line, 1, -1 do
    local line = lines[i]
    
    -- Check for test/it function calls
    local match = line:match("^%s*it%s*%(%s*['\"]([^'\"]+)['\"]") or
                  line:match("^%s*test%s*%(%s*['\"]([^'\"]+)['\"]")
    
    if match then
      test_name = match
      test_start_line = i
      in_test = true
      -- Count opening brace on this line or next lines
      if line:find('{') then
        brace_count = 1
      end
      break
    end
  end

  if not test_name then
    return nil
  end

  -- Now verify the cursor is actually inside this test's scope
  -- by counting braces from the test start to cursor position
  if test_start_line then
    for i = test_start_line, cursor_line do
      local line = lines[i]
      for char in line:gmatch('.') do
        if char == '{' then
          brace_count = brace_count + 1
        elseif char == '}' then
          brace_count = brace_count - 1
          if brace_count == 0 and i < cursor_line then
            -- We've closed the test before reaching cursor
            return nil
          end
        end
      end
    end
  end

  return test_name
end

function M.get_current_test_method()
  -- Try Treesitter first (more accurate)
  local test_method = get_test_method_treesitter()
  if test_method then
    return test_method
  end

  -- Fall back to regex-based detection
  return get_test_method_regex()
end

return M
