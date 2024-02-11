describe("planner default make_call tests", function()
    local orig_pcall = pcall

    local environment = mock({
        set_for_func = function() end,
    })
    local get_breadcrumbs = spy.new(function()
        return {}
    end)
    local output_levels = mock({
        INFO = 1,
        ERROR = 2,
    })

    local mock_pcall = spy.new(function(func, ...)
        return true, "result"
    end)

    local reporter = mock({
        collect = function() end,
    })

    setup(function()
        package.loaded["luabehave.planner.default.environment"] = environment
        package.loaded["luabehave.planner.default.breadcrumbs"] = get_breadcrumbs
        package.loaded["luabehave.output.levels"] = output_levels
        _G.pcall = mock_pcall
    end)

    teardown(function()
        _G.pcall = orig_pcall
        package.loaded["luabehave.planner.default.environment"] = nil
        package.loaded["luabehave.planner.default.breadcrumbs"] = nil
        package.loaded["luabehave.output.levels"] = nil
    end)
    it("should call the function with the given arguments", function()
        local make_call = require("luabehave.planner.default.make_call")
        local acxt = {
            reporter = reporter,
        }
        local context = {
            current_environment = {},
        }
        local step_data = {
            func = function() end,
            args = { "arg1", ["arg2"] = "abc" },
            context_snapshot = "snapshot",
            name = "name"
        }
        local success, result = make_call(acxt, step_data)
        assert.spy(environment.set_for_func).was_called_with(step_data.func,
            step_data.context_snapshot.current_environment)
        assert.spy(mock_pcall).was_called_with(step_data.func, { "arg1", ["arg2"] = "abc" })
        assert.spy(get_breadcrumbs).was_called_with(acxt, step_data.context_snapshot, step_data.name)
        assert.spy(acxt.reporter.collect).was_called_with(acxt, output_levels.INFO, {
            success = true,
            error_description = "result",
            breadcrumbs = {},
        })
        assert.are.equal(true, success)
        assert.are.equal("result", result)
    end)
end)
