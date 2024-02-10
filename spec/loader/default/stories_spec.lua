describe('loader.default.stories', function()
    local orig_io_open = io.open
    local file_obj = {
        read = spy.new(function() return "some content" end),
        close = spy.new(function() end)
    }

    after_each(function()
        package.loaded['luabehave.loader.default.stories'] = nil
        io.open = orig_io_open
    end)

    it('happy path', function()
        io.open = spy.new(function(_, _) return file_obj end)
        local stories_func = require 'luabehave.loader.default.stories'

        local application_context = {
            parser = {
                parse = spy.new(function(file)
                    return true, { "some parsed content" }
                end)
            }
        }

        local file_list = {
            'path/to/stories/_test.extention'
        }
        local ret_value, result = stories_func(application_context, file_list)
        assert.is_true(ret_value)
        assert.are.same({ ["path/to/stories/_test.extention"] = { "some parsed content" } }, result)
        assert.spy(application_context.parser.parse).was.called_with(application_context, file_obj)
        assert.spy(file_obj.close).was.called()
    end)
end)
