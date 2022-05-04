local M = {}

function M.has_directory(name)
    vim.validate({ name = { name, "string" } })
    return function(path)
        return vim.fn.isdirectory(path .. "/" .. name) ~= 0
    end
end

function M.has_readable_file(name)
    vim.validate({ name = { name, "string" } })
    return function(path)
        return vim.fn.filereadable(path .. "/" .. name) ~= 0
    end
end

function M.has_writable_file(name)
    vim.validate({ name = { name, "string" } })
    return function(path)
        return vim.fn.filewritable(path .. "/" .. name) ~= 0
    end
end

function M.glob(pattern)
    vim.validate({ pattern = { pattern, "string" } })
    return function(path)
        return vim.fn.empty(vim.fn.glob(path .. "/" .. pattern)) == 0
    end
end

function M.one_of(...)
    local markers = vim.tbl_flatten({ ... })
    if vim.tbl_isempty(markers) then
        return false
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

function M.all_of(...)
    local markers = vim.tbl_flatten({ ... })
    if vim.tbl_isempty(markers) then
        return true
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

function M.never()
    return false
end

function M.always()
    return true
end

return M
