

describe('finder.default.steps', function()
    local mock_recursive = mock.new(function() end, true)
    setup(function()
        package.loaded["luabehave.finder.default.args"] = function(args)
            return {
                ["finder.default.step.extention"] = "_test.extention",
                ["finder.default.step.path"] = "path/to/steps",
            }
        end
        package.loaded["luabehave.finder.default.recursive"] = mock_recursive
    end)
    teardown(function()
        package.loaded["luabehave.finder.default.args"] = nil
        package.loaded["luabehave.finder.default.recursive"] = nil
    end)
    it('should call recursive search with the correct arguments', function()
        local steps = require 'luabehave.finder.default.steps'

        local application_context = {
            args = {}
        }
        steps(application_context)
        assert.spy(mock_recursive).was_called_with(application_context, 'path/to/steps', '_test.extention')
    end)
end)
