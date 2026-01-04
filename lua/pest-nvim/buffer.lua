local M = {}

local state = {
  buffer = nil,
  window = nil,
}

function M.create_or_reuse_buffer(config)
  if state.window and vim.api.nvim_win_is_valid(state.window) then
    vim.api.nvim_win_close(state.window, true)
  end

  if state.buffer and vim.api.nvim_buf_is_valid(state.buffer) then
    vim.api.nvim_buf_delete(state.buffer, { force = true })
  end

  state.buffer = vim.api.nvim_create_buf(false, true)

  local height = math.floor(vim.o.lines * config.window_size / 100)
  local original_win = vim.api.nvim_get_current_win()
  
  vim.cmd('botright ' .. height .. 'split')
  state.window = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.window, state.buffer)
  
  vim.api.nvim_set_current_win(original_win)

  vim.api.nvim_buf_set_option(state.buffer, 'filetype', 'pest')
  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', false)
  vim.api.nvim_buf_set_option(state.buffer, 'buftype', 'nofile')

  return state.buffer
end

function M.append_to_buffer(lines)
  if not state.buffer or not vim.api.nvim_buf_is_valid(state.buffer) then
    return
  end

  -- Filter out empty trailing lines and ensure no lines contain newline characters
  local filtered_lines = {}
  for _, line in ipairs(lines) do
    if line ~= '' or #filtered_lines > 0 then
      -- Split any lines that contain newline characters
      for split_line in line:gmatch('[^\r\n]+') do
        table.insert(filtered_lines, split_line)
      end
    end
  end

  if #filtered_lines == 0 then
    return
  end

  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', true)
  vim.api.nvim_buf_set_lines(state.buffer, -1, -1, false, filtered_lines)
  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', false)

  if state.window and vim.api.nvim_win_is_valid(state.window) then
    local line_count = vim.api.nvim_buf_line_count(state.buffer)
    vim.api.nvim_win_set_cursor(state.window, { line_count, 0 })
  end
end

function M.clear_buffer()
  if not state.buffer or not vim.api.nvim_buf_is_valid(state.buffer) then
    return
  end

  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', true)
  vim.api.nvim_buf_set_lines(state.buffer, 0, -1, false, {})
  vim.api.nvim_buf_set_option(state.buffer, 'modifiable', false)
end

function M.get_state()
  return state
end

return M
