local utils = require('luabehave.utils')
local parse_steps = require('luabehave.planner.default.step')
local make_call = require("luabehave.planner.default.make_call")

local scenario = {}

function scenario.add_before_step(acxt, context)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function()
        acxt.output.info("Running scenario: " .. context_snapshot.scenario_name)
        if context_snapshot.scenario_unimplemented then
            acxt.output.error(("Unimplemented steps in scenario: %s"):format(context_snapshot.scenario_name))
            return false
        end
        if context.step_implementations.before_scenario then
            return make_call(acxt,
                {
                    context_snapshot = context_snapshot.scenario_name,
                    name = "__before_scenario",
                    func = context.step_implementations.before_scenario.func,
                    args = {}
                })
        end
    end)
end

function scenario.add_after_step(acxt, context)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function()
        if not context_snapshot.scenario_unimplemented then return end

        if context.step_implementations.after_scenario then
            return make_call(acxt,
                {
                    context_snapshot = context_snapshot,
                    name = "__after_scenario",
                    func = context.step_implementations.after_scenario.func,
                    args = {}
                })
        end
    end)
end

local function has_unimplemented_steps_in(scenario_steps, step_implementations)
    local ret_val = false
    for _, step in ipairs(scenario_steps) do
        if not step_implementations[step.name] then
            ret_val = true
            break
        end
    end
    return ret_val
end

function scenario.has_unimplemented_steps(context, parsed_scenario)
    if has_unimplemented_steps_in(parsed_scenario.given_steps,
            context.step_implementations["given"]) then
        return true
    end
    if has_unimplemented_steps_in(parsed_scenario.when_steps,
            context.step_implementations["when"]) then
        return true
    end
    if has_unimplemented_steps_in(parsed_scenario.then_steps,
            context.step_implementations["then"]) then
        return true
    end
    return false
end

function scenario.make_single_plan(acxt, context)
    scenario.add_before_step(acxt, context)
    context.step_type = acxt.keywords.get(acxt).before_step
    parse_steps(acxt, context, context.step_implementations["given"], context.suite.story.scenario.parsed.given_steps)
    context.step_type = acxt.keywords.get(acxt).action_step
    parse_steps(acxt, context, context.step_implementations["when"], context.suite.story.scenario.parsed.when_steps)
    context.step_type = acxt.keywords.get(acxt).after_step
    parse_steps(acxt, context, context.step_implementations["then"], context.suite.story.scenario.parsed.then_steps)
    scenario.add_after_step(acxt, context)
end

function scenario.make_plan(acxt, context)
    local story = context.suite.story.parsed
    for _, parsed_scenario in ipairs(story.scenarios) do
        local unimplemented = scenario.has_unimplemented_steps(context, parsed_scenario)
        if unimplemented then
            context:init_scenario(parsed_scenario, ("[Unimplemented]: %s"):format(parsed_scenario.name))
            context.suite.story.scenario.unimplemented = true
            scenario.make_single_plan(acxt, context)
        elseif parsed_scenario.examples then
            for example_row_number, example in ipairs(parsed_scenario.examples) do
                context:init_scenario(parsed_scenario,
                    ("[#%d]: %s"):format(example_row_number, parsed_scenario.name))
                context.suite.story.scenario.examples.present = true
                context.suite.story.scenario.examples.row_number = example_row_number
                context.suite.story.scenario.examples.args = example
                scenario.make_single_plan(acxt, context)
            end
        else
            context:init_scenario(parsed_scenario, parsed_scenario.name)
            scenario.make_single_plan(acxt, context)
        end
    end
end

return scenario
