local M = {}

local state = {
  job_id = nil,
  buffer = nil,
  window = nil,
}

function M.run(cmd, callback)
  if state.job_id then
    vim.fn.jobstop(state.job_id)
    state.job_id = nil
  end

  state.job_id = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      if data and #data > 0 then
        callback(data)
      end
    end,
    on_stderr = function(_, data, _)
      if data and #data > 0 then
        callback(data)
      end
    end,
    on_exit = function(_, code, _)
      state.job_id = nil
      callback({ '', '[Process exited with code ' .. code .. ']' })
    end,
    stdout_buffered = false,
  })
end

function M.get_state()
  return state
end

function M.reset_state()
  state.job_id = nil
end

return M
