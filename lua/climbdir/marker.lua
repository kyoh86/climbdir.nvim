local M = {}

---@alias climbdir.marker.Marker fun(path: string): boolean
---@return boolean

---Create a marker to check the directory has a directory with the name.
---@param name string @Target directory name
---@return climbdir.marker.Marker
function M.has_directory(name)
  vim.validate({ name = { name, "string" } })
  return function(path)
    return vim.fn.isdirectory(path .. "/" .. name) ~= 0
  end
end

---Create a marker to check the directory has a readable-file with the name.
---@param name string @Target file name
---@return climbdir.marker.Marker
function M.has_readable_file(name)
  vim.validate({ name = { name, "string" } })
  return function(path)
    return vim.fn.filereadable(path .. "/" .. name) ~= 0
  end
end

---Create a marker to check the directory has a writable-file with the name.
---@param name string @Target file name
---@return climbdir.marker.Marker
function M.has_writable_file(name)
  vim.validate({ name = { name, "string" } })
  return function(path)
    return vim.fn.filewritable(path .. "/" .. name) ~= 0
  end
end

---Create a marker to check the directory has any file with the glob.
---@param pattern string @Target file glob pattern
---@return climbdir.marker.Marker
function M.glob(pattern)
  vim.validate({ pattern = { pattern, "string" } })
  return function(path)
    return vim.fn.empty(vim.fn.glob(path .. "/" .. pattern)) == 0
  end
end

---Create a marker to check the path matched by any of the matchers.
---@vararg climbdir.marker.Marker
---@return climbdir.marker.Marker
function M.one_of(...)
  ---@type climbdir.marker.Marker[]
  local markers = vim.iter({ ... }):flatten():totable()
  if vim.tbl_isempty(markers) then
    return M.never
  end
  return function(path)
    for _, marker in ipairs(markers) do
      if marker(path) then
        return true
      end
    end
    return false
  end
end

---Create a marker to check the path matched by all of the matchers.
---@vararg climbdir.marker.Marker
---@return climbdir.marker.Marker
function M.all_of(...)
  local markers = vim.iter({ ... }):flatten():totable()
  if vim.tbl_isempty(markers) then
    return M.always
  end
  return function(path)
    for _, marker in ipairs(markers) do
      if not (marker(path)) then
        return false
      end
    end
    return true
  end
end

---Create a inverted marker.
---@param marker climbdir.marker.Marker
---@return climbdir.marker.Marker
function M.not_of(marker)
  return function(path)
    return not marker(path)
  end
end

---Create a marker to deny anything.
function M.never(_)
  return false
end

---Create a marker to accept anything.
function M.always(_)
  return true
end

return M
