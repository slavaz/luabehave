
describe('finder.default.stories', function()
    local mock_recursive = mock.new(function() end, true)

    setup(function()
        package.loaded["luabehave.finder.default.args"] = function(args)
            return {
                ["finder.default.story.extention"] = "_test.extention",
                ["finder.default.story.path"] = "path/to/stories",
            }
        end
        package.loaded["luabehave.finder.default.recursive"] = mock_recursive
    end)
    teardown(function()
        package.loaded["luabehave.finder.default.args"] = nil
        package.loaded["luabehave.finder.default.recursive"] = nil
    end)
    it('should call recursive search with the correct arguments', function()
        local stories = require 'luabehave.finder.default.stories'

        local application_context = {
            args = {}
        }
        stories(application_context)
        assert.spy(mock_recursive).was_called_with(application_context, 'path/to/stories', '_test.extention')
    end)
end)
