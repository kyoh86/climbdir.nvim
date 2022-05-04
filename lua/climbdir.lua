-- Climb dirs

local M = {}

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

function M.climb(start_path, marker, opts)
    vim.validate({
        marker = { marker, "function" },
        start_path = { start_path, "string" },
        opts = { opts, "table", true },
    })
    return climb(start_path, marker, opts or {})
end

return M
