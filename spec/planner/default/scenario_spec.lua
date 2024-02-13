_G["__tests"] = {}
local Context = require("luabehave.planner.default.context")

local package_name = "luabehave.planner.default.scenario"
local function get_private()
    return _G["__tests"]["planner_scenario_private"]
end

describe("tests for #planner.default.scenario", function()
    local assert_snapshot
    local prepare_steps = spy()

    before_each(function()
        assert_snapshot = assert:snapshot()
        package.loaded["luabehave.planner.default.step"] = prepare_steps
    end)
    after_each(function()
        assert_snapshot:revert()
        prepare_steps:clear()
        package.loaded[package_name] = nil
        package.loaded["luabehave.planner.default.step"] = nil
    end)

    it("should add before step", function()
        require(package_name)
        local private = get_private()
        local context = Context({}, {
            before_story = { func = function() end },
            before_scenario = { func = function() end },
            before_suite = { func = function() end },
        })
        local acxt = {
            keywords = {
                get = function(s) return { scenario = "Scenario", } end
            }
        }
        private.prepare_before_handler(acxt, context)
        assert.is.equal(1, #context.executable_steps)
        assert.are.same({
            keyword = "Scenario",
            context_snapshot = context:snapshot(),
            step = {
                name = "__before_scenario",
                func = context.step_implementations.before_scenario.func,
                args = {},
            }
        }, context.executable_steps[1])
    end)

    it("should add after step", function()
        require(package_name)
        local private = get_private()
        local context = Context({}, {
            after_story = { func = function() end },
            after_scenario = { func = function() end },
            after_suite = { func = function() end },
        })
        local acxt = {
            keywords = {
                get = function(s) return { scenario = "Scenario", } end
            }
        }
        private.prepare_after_handler(acxt, context)
        assert.is.equal(1, #context.executable_steps)
        assert.are.same({
            keyword = "Scenario",
            context_snapshot = context:snapshot(),
            step = {
                name = "__after_scenario",
                func = context.step_implementations.after_scenario.func,
                args = {},
            }
        }, context.executable_steps[1])
    end)
    it("should prepare a single plan", function()
        require(package_name)
        local private = get_private()
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
                        scenario = "Scenario",
                        before_step = "Given",
                        action_step = "When",
                        after_step = "Then",
                    }
                end
            }
        }
        private.prepare_single_plan(acxt, context)
        assert.spy(prepare_steps).was_called(3)
        assert.is.equal(2, #context.executable_steps)
        assert.are.same({
            keyword = "Scenario",
            context_snapshot = context:snapshot(),
            step = {
                name = "__before_scenario",
                func = nil,
                args = {},
            }
        }, context.executable_steps[1])
        assert.are.same({
            keyword = "Scenario",
            context_snapshot = context:snapshot(),
            step = {
                name = "__after_scenario",
                func = nil,
                args = {},
            }
        }, context.executable_steps[2])
    end)

    it("should check if scenario has unimplemented steps", function()
        require(package_name)
        local private = get_private()

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
        assert.is_false(private.has_unimplemented_steps(context, parsed_scenario))
        context.step_implementations["given"]["step1"] = nil
        assert.is_true(private.has_unimplemented_steps(context, parsed_scenario))
    end)

    it("should make a plan for unimplemented steps", function()
        local scenario_func = require(package_name)
        local private = get_private()
        private.prepare_single_plan = spy(function(acxt, context)
        end)
        private.has_unimplemented_steps = spy(function(context)
            return true
        end)
        local context = Context({}, {})
        context.suite.story.parsed = {
            scenarios = {
                { name = "scenario1" }
            }
        }
        scenario_func({}, context)
        assert.is.equal(1, context.suite.story.scenario.number)
        assert.spy(private.prepare_single_plan).was_called(1)
        assert.is.equal("scenario1", context.suite.story.scenario.name)
        assert.is_true(context.suite.story.scenario.unimplemented)
        assert.is_false(context.suite.story.scenario.examples.present)
    end)

    it("should make a plan for scenarios with examples", function()
        local scenario_func = require(package_name)
        local private = get_private()
        private.prepare_single_plan = spy(function(acxt, context)
        end)
        private.has_unimplemented_steps = spy(function(context)
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
        scenario_func({}, context)
        assert.spy(private.prepare_single_plan).was_called(1)
        assert.is.equal("scenario1", context.suite.story.scenario.name)
        assert.is.equal(1, context.suite.story.scenario.number)
        assert.is_false(context.suite.story.scenario.unimplemented)
        assert.is_true(context.suite.story.scenario.examples.present)
        assert.is.equal(1, context.suite.story.scenario.examples.row_number)
        assert.is.same({ "a", "b" }, context.suite.story.scenario.examples.args)
    end)
    it("should make a plan for a scenarion without examnples", function()
        local scenario_func = require(package_name)
        local private = get_private()
        private.prepare_single_plan = spy(function(acxt, context) end)
        private.has_unimplemented_steps = spy(function(context) return false end)
        local context = Context({}, {})
        context.suite.story.parsed = {
            scenarios = {
                { name = "scenario1" }
            }
        }
        scenario_func({}, context)
        assert.spy(private.prepare_single_plan).was_called(1)
        assert.is.equal("scenario1", context.suite.story.scenario.name)
        assert.is.equal(1, context.suite.story.scenario.number)
        assert.is_false(context.suite.story.scenario.unimplemented)
        assert.is_false(context.suite.story.scenario.examples.present)
    end)
end)
