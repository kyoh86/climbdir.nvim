-- Climb dirs

local M = {}

--- Climb up directories to find marker
---@param path string @A path of the directory starting climb up from.
---@param marker climbdir.marker.Marker @A marker function that checks a path which is matched or not
---                     We can get a simple marker from climbdir.marker module.
---@param opts {halt:function} @A dictionary of options.
---                     - halt (function): a function receives a path to halt climb-up.
---@return string|nil @Found ancestor path.
local function climb(path, marker, opts)
  if marker(path) then
    return path
  end
  if opts.halt and opts.halt(path) then
    return nil
  end
  local parent = vim.fn.fnamemodify(path, ":h")
  if parent == path or (vim.fn.has("win32") and parent:match("^//[^/]\\+$")) then
    return nil
  end
  return climb(parent, marker, opts)
end

--- Climb up directories to find marker
---@param start_path string @A path of the directory starting climb up from.
---@param marker climbdir.marker.Marker @A marker function that checks a path which is matched or not
---                     We can get a simple marker from climbdir.marker module.
---@param opts {halt:function}? @A dictionary of options.
---                     - halt (function): a function receives a path to halt climb-up.
---@return string|nil @Found ancestor path.
function M.climb(start_path, marker, opts)
  vim.validate({
    start_path = { start_path, "string" },
    marker = { marker, "function" },
    opts = { opts, "table", true },
  })
  return climb(start_path, marker, opts or {})
end

return M
