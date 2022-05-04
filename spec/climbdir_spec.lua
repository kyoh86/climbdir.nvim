describe("climbdir", function()
    local testtarget = require("climbdir")
    local marker = require("climbdir.marker")
    local dir = ""
    local sub1 = ""
    local sub2 = ""

    local buf = vim.api.nvim_create_buf(true, false)
    local touch = function(name)
        vim.api.nvim_buf_call(buf, function()
            vim.cmd("write " .. name)
        end)
    end

    before_each(function()
        if dir ~= nil and dir ~= "" then
            vim.fn.delete(dir, "rf")
        end

        dir = vim.fn.tempname()

        assert.is.not_nil(dir)
        assert.not_equal("", dir)

        sub1 = dir .. "/sub1"
        sub2 = dir .. "/sub2"

        vim.fn.mkdir(sub1, "p")
        vim.fn.mkdir(sub2, "p")
    end)

    after_each(function()
        if dir ~= nil and dir ~= "" then
            vim.fn.delete(dir, "rf")
        end
    end)

    describe("has directory", function()
        it("not found", function()
            local m = marker.has_directory("it-will-be-not-found-ever")
            assert.is_false(m(sub1))
            assert.is_nil(testtarget.climb(sub1, m))
        end)

        it("found", function()
            local name = "it-will-be-found"
            vim.fn.mkdir(dir .. "/" .. name)

            local m = marker.has_directory(name)
            assert.is_true(m(dir))
            assert.equals(dir, testtarget.climb(sub1, m))
        end)
    end)

    describe("has readable file", function()
        it("not found", function()
            local m = marker.has_readable_file("it-will-be-not-found-ever.txt")
            assert.is_false(m(sub1))
            assert.is_nil(testtarget.climb(sub1, m))
        end)

        -- TODO: check if the file is not readable

        it("not found that is directory", function()
            local name = "it-is-directory"
            vim.fn.mkdir(dir .. "/" .. name)

            local m = marker.has_readable_file(name)
            assert.is_false(m(dir))
            assert.is_nil(testtarget.climb(sub1, m))
        end)

        it("found", function()
            local name = "it-will-be-found.txt"
            touch(dir .. "/" .. name)

            local m = marker.has_readable_file(name)
            assert.is_true(m(dir))
            assert.equals(dir, testtarget.climb(sub1, m))
        end)
    end)

    describe("has writable file", function()
        it("not found", function()
            local m = marker.has_writable_file("it-will-be-not-found-ever.txt")
            assert.is_false(m(sub1))
            assert.is_nil(testtarget.climb(sub1, m))
        end)

        -- TODO: check if the file is not writable

        it("found", function()
            local name = "it-will-be-found.txt"
            touch(dir .. "/" .. name)

            local m = marker.has_writable_file(name)
            assert.is_true(m(dir))
            assert.equals(dir, testtarget.climb(sub1, m))
        end)
    end)

    describe("glob", function()
        it("not found", function()
            local m = marker.glob("it-will-be-not-found-ever.txt")
            assert.is_false(m(sub1))
            assert.is_nil(testtarget.climb(sub1, m))
        end)

        it("found dir", function()
            local name = "it-will-be-found"
            vim.fn.mkdir(dir .. "/" .. name, "p")

            local glob = "it-will-be-found*"
            local m = marker.glob(glob)
            assert.is_true(m(dir))
            assert.equals(dir, testtarget.climb(sub1, m))
        end)

        it("found file", function()
            local name = "it-will-be-found.txt"
            touch(dir .. "/" .. name)

            local glob = "it-will-be-found*"
            local m = marker.glob(glob)
            assert.is_true(m(dir))
            assert.equals(dir, testtarget.climb(sub1, m))
        end)
    end)
end)
