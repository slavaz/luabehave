describe("default planner init", function()
    local default_planner
    local ContextClass
    local suite

    setup(function()
        ContextClass = spy(function(stories, step_implementations)
            local self = {}
            self.stories = stories
            self.step_implementations = step_implementations
            return self
        end)
        package.loaded["luabehave.planner.default.context"] = ContextClass
        suite = mock({
            make_plan = function(acxt, context_obj)
                return {}
            end
        })
        package.loaded["luabehave.planner.default.suite"] = suite
    end)
    teardown(function()
        package.loaded["luabehave.planner.default.context"] = nil
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
        local plan = default_planner.make_plan(acxt, stories, step_implementations)
        assert.are.same({}, plan)
        assert.spy(ContextClass).was_called_with(stories, step_implementations)
        assert.spy(suite.make_plan).was_called_with(acxt, context_expected)
    end)
end)
