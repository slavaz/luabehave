_G["__tests"] = {}
local Context = require("luabehave.planner.default.context")

local package_name = "luabehave.planner.default.suite"

local function get_private()
    return _G["__tests"]["planner_suite_private"]
end
describe("tests for #default.planner.suite", function()
    local assert_snapshot

    local mock = {
        get_suites = spy(function(acxt, context)
            return { "suite1", }
        end),
        story_func = spy(function(acxt, context, suite)
            return true, "result"
        end),
    }

    before_each(function()
        package.loaded["luabehave.planner.default.story"] = mock.story_func
        package.loaded["luabehave.planner.default.suite_list"] = mock.get_suites
        assert_snapshot = assert:snapshot()
    end)
    after_each(function()
        package.loaded["luabehave.planner.default.validate_args"] = nil
        package.loaded["luabehave.planner.default.story"] = nil
        package.loaded["luabehave.planner.default.suite_list"] = nil
        assert_snapshot:revert()
        for k, v in pairs(mock) do v:clear() end
        package.loaded[package_name] = nil
    end)

    it("should prepare before suite handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            keywords = {
                get = function(acxt) return { suite = "suite" } end
            }
        }
        local context = Context({}, {})
        context.step_implementations = {
            before_suite = {
                func = function() end
            }
        }
        context.executable_steps = {}
        context.snapshot = function() return {} end
        private.prepare_before_suite_handler(acxt, context)
        assert.are.same(1, #context.executable_steps)
        assert.are.same({
            keyword = "suite",
            context_snapshot = {},
            step = {
                name = "__before_suite",
                func = context.step_implementations.before_suite.func,
                args = {}
            }
        }, context.executable_steps[1])
    end)
    it("should prepare after suite handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            keywords = {
                get = function(acxt) return { suite = "suite" } end
            }
        }
        local context = Context({}, {})
        context.step_implementations = {
            after_suite = {
                func = function() end
            }
        }
        context.executable_steps = {}
        context.snapshot = function() return {} end
        private.prepare_after_suite_handler(acxt, context)
        assert.are.same(1, #context.executable_steps)
        assert.are.same({
            keyword = "suite",
            context_snapshot = {},
            step = {
                name = "__after_suite",
                func = context.step_implementations.after_suite.func,
                args = {}
            }
        }, context.executable_steps[1])
    end)
    it("should prepare siotes plan", function()
        local suite_func = require(package_name)
        local private = get_private()
        private.prepare_before_suite_handler = spy.new(function() end)
        private.prepare_after_suite_handler = spy.new(function() end)

        local acxt = {}
        local context = Context({}, {})
        suite_func(acxt, context)
        assert.spy(private.prepare_before_suite_handler).was.called(1)
        assert.spy(private.prepare_after_suite_handler).was.called(1)
        assert.spy(mock.get_suites).was.called(1)
        assert.spy(mock.story_func).was.called(1)
        assert.is.equal("suite1", context.suite.name)
    end)
end)
