local function table_has_a_value(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

describe('finder.default.steps', function()
    setup(function()
        package.loaded["lfs"] = {
            dir = function(path)
                if path == 'path/to/files' then
                    return coroutine.wrap(function()
                        coroutine.yield('.')
                        coroutine.yield('..')
                        coroutine.yield('dir1')
                        coroutine.yield('dir2')
                        coroutine.yield('story1.story')
                        coroutine.yield('story2.story')
                    end)
                end
                if path == 'path/to/files/dir1' then
                    return coroutine.wrap(function()
                        coroutine.yield('.')
                        coroutine.yield('..')
                        coroutine.yield('story3.story')
                    end)
                end
                if path == 'path/to/files/dir2' then
                    return coroutine.wrap(function()
                        coroutine.yield('.')
                        coroutine.yield('..')
                        coroutine.yield('story4.story')
                    end)
                end
                return coroutine.wrap(function()
                end)
            end,
            attributes = function(path)
                if path == 'path/to/files' then
                    return { mode = "directory" }
                end
                if path == 'path/to/files/dir1' then
                    return { mode = "directory" }
                end
                if path == 'path/to/files/dir2' then
                    return { mode = "directory" }
                end
                return { mode = "file" }
            end
        }
    end)
    teardown(function()
        package.loaded["lfs"] = nil
    end)
    it('should call recursive search with the correct arguments', function()
        local recursive = require 'luabehave.finder.default.recursive'

        local ret_val, result = recursive({}, 'path/to/files', '.story')
        assert.is_true(ret_val)

        assert.is_true(table_has_a_value(result, 'path/to/files/dir2/story4.story'))
        assert.is_true(table_has_a_value(result, 'path/to/files/story2.story'))
        assert.is_true(table_has_a_value(result, 'path/to/files/dir1/story3.story'))
        assert.is_true(table_has_a_value(result, 'path/to/files/story1.story'))
        assert.is_equal(4, #result)
    end)
end)
