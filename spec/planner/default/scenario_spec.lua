local Context = require("luabehave.planner.default.context")
describe("tests for planner scenario", function()
    local parse_steps = spy(function(acxt, context, implemented_steps, steps)
    end)

    local make_call = spy(function(acxt, context, args)
    end)

    setup(function()
        package.loaded["luabehave.planner.default.step"] = parse_steps
        package.loaded["luabehave.planner.default.make_call"] = make_call
    end)

    teardown(function()
        package.loaded["luabehave.planner.default.step"] = nil
        package.loaded["luabehave.planner.default.make_call"] = nil
    end)

    it("should add before step", function()
        local scenario = require("luabehave.planner.default.scenario")
        local context = Context({}, {
            before_scenario = {
                func = function() end
            }
        })
        local acxt = {
        }
        scenario.add_before_step(acxt, context)
        assert.spy(parse_steps).was_not_called()
        assert.is.equal(1, #context.executable_steps)
    end)

    it("should add after step", function()
        local scenario = require("luabehave.planner.default.scenario")
        local context = Context({}, {
            after_scenario = {
                func = function() end
            }
        })
        local acxt = {
        }
        scenario.add_after_step(acxt, context)
        assert.spy(parse_steps).was_not_called()
        assert.is.equal(1, #context.executable_steps)
    end)
    it("should make a single plan", function()
        local scenario = require("luabehave.planner.default.scenario")
        local context = Context({}, { ['given'] = {}, ['when'] = {}, ['then'] = {} })
        context.suite.story.scenario = {
            parsed = {
                given_steps = { { name = "step1" }, },
                when_steps = { { name = "step2" }, },
                then_steps = { { name = "step3" } },
            },
            examples = {
                present = false,
                args = {},
                row_number = 0,
            }
        }
        local acxt = {
            keywords = {
                get = function(s)
                    return {
                        before_step = "Given",
                        action_step = "When",
                        after_step = "Then",
                    }
                end
            }
        }
        scenario.make_single_plan(acxt, context)
        assert.spy(parse_steps).was_called(3)
        assert.is.equal(2, #context.executable_steps)
    end)


    it("should check if scenario has unimplemented steps", function()
        local scenario = require("luabehave.planner.default.scenario")

        local parsed_scenario = {
            given_steps = { { name = "step1" }, },
            when_steps = { { name = "step2" }, },
            then_steps = { { name = "step3" }, }
        }
        local context = {
            step_implementations = {
                ["given"] = { ["step1"] = true },
                ["when"] = { ["step2"] = true },
                ["then"] = { ["step3"] = true },
            }
        }
        assert.is_false(scenario.has_unimplemented_steps(context, parsed_scenario))
        context.step_implementations["given"]["step1"] = nil
        assert.is_true(scenario.has_unimplemented_steps(context, parsed_scenario))
    end)

    it("should make a plan for unimplemented steps", function()
        local scenario = require("luabehave.planner.default.scenario")
        scenario.make_single_plan = spy(function(acxt, context)
        end)
        scenario.has_unimplemented_steps = spy(function(context)
            return true
        end)
        local context = Context({}, {})
        context.suite.story.parsed = {
            scenarios = {
                { name = "scenario1" }
            }
        }
        scenario.make_plan({}, context)
        assert.spy(scenario.make_single_plan).was_called(1)
        assert.is.equal("[Unimplemented]: scenario1", context.suite.story.scenario.name)
        assert.is_true(context.suite.story.scenario.unimplemented)
        assert.is_false(context.suite.story.scenario.examples.present)
    end)

    it("should make a plan for scenarios with examples", function()
        local scenario = require("luabehave.planner.default.scenario")
        scenario.make_single_plan = spy(function(acxt, context)
        end)
        scenario.has_unimplemented_steps = spy(function(context)
            return false
        end)
        local context = Context({}, {})
        context.suite.story.parsed = {
            scenarios = {
                {
                    name = "scenario1",
                    examples = {
                        { "a", "b" },
                    }
                }
            }
        }
        scenario.make_plan({}, context)
        assert.spy(scenario.make_single_plan).was_called(1)
        assert.is.equal("[#1]: scenario1", context.suite.story.scenario.name)
        assert.is_false(context.suite.story.scenario.unimplemented)
        assert.is_true(context.suite.story.scenario.examples.present)
        assert.is.equal(1, context.suite.story.scenario.examples.row_number)
        assert.is.same({ "a", "b" }, context.suite.story.scenario.examples.args)
    end)
    it("should make a plan for a scenarion without examnples", function()
        local scenario = require("luabehave.planner.default.scenario")
        scenario.make_single_plan = spy(function(acxt, context)
        end)
        scenario.has_unimplemented_steps = spy(function(context)
            return false
        end)
        local context = Context({}, {})
        context.suite.story.parsed = {
            scenarios = {
                { name = "scenario1" }
            }
        }
        scenario.make_plan({}, context)
        assert.spy(scenario.make_single_plan).was_called(1)
        assert.is.equal("scenario1", context.suite.story.scenario.name)
        assert.is_false(context.suite.story.scenario.unimplemented)
        assert.is_false(context.suite.story.scenario.examples.present)
    end)
end)
