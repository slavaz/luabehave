describe("default planner suite tests", function()
    local Context = require("luabehave.planner.default.context")
    local get_suites = spy(function(acxt, context)
        return { "suite1", "suite2" }
    end)

    local make_stories_plan = spy(function(acxt, context, suite)
        return true, "result"
    end)

    setup(function()
        package.loaded["luabehave.planner.default.story"] = make_stories_plan
        package.loaded["luabehave.planner.default.suite_list"] = get_suites
    end)

    teardown(function()
        package.loaded["luabehave.planner.default.validate_args"] = nil
        package.loaded["luabehave.planner.default.story"] = nil
        package.loaded["luabehave.planner.default.suite_list"] = nil
    end)

    it("should call the before_suite function", function()
        local suite = require("luabehave.planner.default.suite")

        local acxt = {}
        local stories = {}

        local step_implementations = {
            before_suite = {
                func = function() end,
            }
        }
        local context = Context(stories, step_implementations)
        local success, result = suite.make_plan(acxt, context)
        assert.are.equal(true, success)
        assert.is_table(result)
        assert.are.equal(4, #result)
        assert.spy(make_stories_plan).was.called(2)
    end)
end)
