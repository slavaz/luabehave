_G["__tests"] = {}
local Context = require("luabehave.planner.default.context")
local package_name = "luabehave.planner.default.step"

describe("Tests for #planner.default.step", function()
    local assert_snapshot

    before_each(function()
        assert_snapshot = assert:snapshot()
    end)
    after_each(function()
        assert_snapshot:revert()
        package.loaded[package_name] = nil
    end)
    it("should add a step into steps implementation table", function()
        local prepare_step = require(package_name)
        local context = Context({}, {})
        context.suite.story.scenario.parsed = {
            given_steps = {
                { name = "step1", args = {} }
            }
        }
        local implemented_steps = {
            step1 = { func = function() end }
        }
        local story_steps = {
            { name = "step1", args = {} }
        }
        local steps_keyword = "Given"
        prepare_step(context, implemented_steps, story_steps, steps_keyword)
        assert.are.equal(1, #context.executable_steps)
        assert.are.same({
            keyword = "Given",
            context_snapshot = context:snapshot(),
            step = {
                name = "step1",
                func = implemented_steps.step1.func,
                args = {},
            }
        }, context.executable_steps[1])
    end)
    it("should add a step without implementation into steps implementation table", function()
        local prepare_step = require(package_name)
        local context = Context({}, {})
        context.suite.story.scenario.parsed = {
            given_steps = {
                { name = "step1", args = {} }
            }
        }
        local implemented_steps = {}
        local story_steps = {
            { name = "step1", args = {} }
        }
        local steps_keyword = "Given"
        prepare_step(context, implemented_steps, story_steps, steps_keyword)
        assert.are.equal(1, #context.executable_steps)
        assert.are.same({
            keyword = "Given",
            context_snapshot = context:snapshot(),
            step = {
                name = "step1",
                func = nil,
                args = {},
            }
        }, context.executable_steps[1])
    end)
end)
