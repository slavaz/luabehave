local ContextClass = require("luabehave.planner.default.context")
describe("Tests for #planner.default.init", function()
    local default_planner
    local suite_func = spy.new(function(acxt, context_obj) return { "some execution plan" } end)

    setup(function()
        package.loaded["luabehave.planner.default.suite"] = suite_func
    end)
    teardown(function()
        package.loaded["luabehave.planner.default.suite"] = nil
    end)

    it("should have a name function", function()
        default_planner = require("luabehave.planner.default.init")
        assert.are.equal("default", default_planner.name())
    end)

    it("should have a make_plan function", function()
        default_planner = require("luabehave.planner.default.init")

        local stories = { "story1" }
        local step_implementations = { "step1" }
        local context_expected = ContextClass(stories, step_implementations)
        local acxt = {}
        local plan = assert(default_planner.prepare_plan(acxt, stories, step_implementations))
        assert.are.same({ "some execution plan" }, plan)
        assert.spy(suite_func).was.called_with(acxt, context_expected)
    end)
end)
