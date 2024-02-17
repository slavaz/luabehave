_G["__tests"] = {}
local function get_private()
    return _G["__tests"]["runner_default_execute"]
end
local package_name = "luabehave.runner.default.execute"

describe("Tests for #runner.default.execute", function()
    local assert_snapshot

    local spy_funcs = {
        reporter__show = spy.new(function() end),
        reporter__collect = spy.new(function() end),
        environment__set_for_func = spy.new(function() end),
    }
    local mock = {
        reporter = {
            show = spy_funcs.reporter__show,
            collect = spy_funcs.reporter__collect,
        },
        environment =
        {
            set_for_func = spy_funcs.environment__set_for_func,
        }
    }

    before_each(function()
        package.loaded["luabehave.reporter.default"] = mock.reporter
        package.loaded["luabehave.environment"] = mock.environment
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
    end)

    it("should recognize unimplemented steps in a story", function()
        require(package_name)
        local parametrized = {
            { story = true,  scenario = false, result = true },
            { story = false, scenario = true,  result = true },
            { story = true,  scenario = true,  result = true },
            { story = false, scenario = false, result = false },
        }
        for _, v in ipairs(parametrized) do
            local step_context = {
                context_snapshot = {
                    suite = {
                        story = {
                            unimplemented = v.story,
                            scenario = {
                                unimplemented = v.scenario,
                            },
                        },
                    },
                },
            }
            local result = get_private().is_step_unimplemented(step_context)
            assert.is_equal(v.result, result)
        end
    end)
    it("Should not execute step if no any functions defined", function()
        require(package_name)
        local private = get_private()

        local step_context = {
            step = {
                func = nil,
            },
        }
        local result = private.execute_step({}, step_context)
        assert.is_true(result)
        assert.is_true(step_context.success)
        assert.spy(spy_funcs.environment__set_for_func).was_not_called()
        assert.spy(spy_funcs.reporter__show).was_not_called()
        assert.spy(spy_funcs.reporter__collect).was_not_called()
    end)
    it("Should execute step and return true if success", function()
        require(package_name)
        local private = get_private()

        local step_context = {
            step = {
                func = function() end,
                args = {},
            },
            context_snapshot = {
                current_environment = {},
            },
        }
        local result = private.execute_step({}, step_context)
        assert.is_true(result)
        assert.is_true(step_context.success)
        assert.spy(spy_funcs.environment__set_for_func).was_called_with(step_context.step.func,
            step_context.context_snapshot.current_environment)
        assert.spy(spy_funcs.reporter__show).was_not_called()
        assert.spy(spy_funcs.reporter__collect).was_not_called()
    end)
    it("Should execute step and return false if failed", function()
        require(package_name)
        local private = get_private()

        local step_context = {
            step = {
                func = function() error("error") end,
                args = {},
            },
            context_snapshot = {
                current_environment = {},
            },
        }
        local result = private.execute_step({}, step_context)
        assert.is_false(result)
        assert.is_false(step_context.success)
        assert.spy(spy_funcs.environment__set_for_func).was_called_with(step_context.step.func,
            step_context.context_snapshot.current_environment)
        assert.spy(spy_funcs.reporter__show).was_not_called()
        assert.spy(spy_funcs.reporter__collect).was_not_called()
    end)
    it("should execute execution plan", function()
        local execute_func = require("luabehave.runner.default.execute")
        local private = get_private()
        private.is_step_unimplemented = function() return false end
        local execution_plan = {
            { step = { func = function() end, args = {} },                context_snapshot = { current_environment = {} } },
            { step = { func = function() error("error") end, args = {} }, context_snapshot = { current_environment = {} } },
        }
        local acxt = {
            output = {
                error = function() end,
            },
            runner_results = {
                has_unimplemented_steps = false,
                has_failed_steps = false,
            },
        }
        execute_func(acxt, execution_plan)
        assert.is_false(acxt.runner_results.has_unimplemented_steps)
        assert.is_true(acxt.runner_results.has_failed_steps)
        assert.spy(spy_funcs.environment__set_for_func).was_called(2)
        assert.spy(spy_funcs.reporter__show).was_called(2)
        assert.spy(spy_funcs.reporter__collect).was_called(2)
    end)
end)
