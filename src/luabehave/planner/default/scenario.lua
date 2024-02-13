local utils = require('luabehave.utils')
local parse_steps = require('luabehave.planner.default.step')
local has_unimplemented_steps_in = require('luabehave.planner.default.has_unimplemented')

local private = {}
if _G["__tests"] then
    _G["__tests"]["planner_scenario_private"] = private
end

function private.prepare_before_handler(acxt, planner_context)
    local func = planner_context.step_implementations.before_scenario
        and planner_context.step_implementations.before_scenario.func or nil
    utils.add_to_table(planner_context.executable_steps, {
        keyword = acxt.keywords.get(acxt).scenario,
        context_snapshot = planner_context:snapshot(),
        step = {
            name = "__before_scenario",
            func = func,
            args = {},
        },
    })
end

function private.prepare_after_handler(acxt, planner_context)
    local func = planner_context.step_implementations.after_scenario
        and planner_context.step_implementations.after_scenario.func or nil
    utils.add_to_table(planner_context.executable_steps, {
        keyword = acxt.keywords.get(acxt).scenario,
        context_snapshot = planner_context:snapshot(),
        step = {
            name = "__after_scenario",
            func = func,
            args = {},
        },
    })
end

function private.has_unimplemented_steps(planner_context, parsed_scenario)
    if has_unimplemented_steps_in(parsed_scenario.given_steps,
            planner_context.step_implementations["given"]) then
        return true
    end
    if has_unimplemented_steps_in(parsed_scenario.when_steps,
            planner_context.step_implementations["when"]) then
        return true
    end
    if has_unimplemented_steps_in(parsed_scenario.then_steps,
            planner_context.step_implementations["then"]) then
        return true
    end
    return false
end

function private.prepare_single_plan(acxt, planner_context)
    private.prepare_before_handler(acxt, planner_context)

    parse_steps(planner_context,
        planner_context.step_implementations["given"],
        planner_context.suite.story.scenario.parsed.given_steps,
        acxt.keywords.get(acxt).before_step
    )
    parse_steps(planner_context,
        planner_context.step_implementations["when"],
        planner_context.suite.story.scenario.parsed.when_steps,
        acxt.keywords.get(acxt).action_step
    )
    parse_steps(planner_context,
        planner_context.step_implementations["then"],
        planner_context.suite.story.scenario.parsed.then_steps,
        acxt.keywords.get(acxt).after_step
    )
    private.prepare_after_handler(acxt, planner_context)
end

return function(acxt, planner_context)
    local story = planner_context.suite.story.parsed
    for number, parsed_scenario in ipairs(story.scenarios) do
        local unimplemented = private.has_unimplemented_steps(planner_context, parsed_scenario)
        if unimplemented then
            planner_context:init_scenario(parsed_scenario, parsed_scenario.name)
            planner_context.suite.story.scenario.number = number
            planner_context.suite.story.scenario.unimplemented = true
            private.prepare_single_plan(acxt, planner_context)
        elseif parsed_scenario.examples then
            for example_row_number, example in ipairs(parsed_scenario.examples) do
                planner_context:init_scenario(parsed_scenario, parsed_scenario.name)
                planner_context.suite.story.scenario.number = number
                planner_context.suite.story.scenario.examples.present = true
                planner_context.suite.story.scenario.examples.row_number = example_row_number
                planner_context.suite.story.scenario.examples.args = example
                private.prepare_single_plan(acxt, planner_context)
            end
        else
            planner_context:init_scenario(parsed_scenario, parsed_scenario.name)
            planner_context.suite.story.scenario.number = number
            private.prepare_single_plan(acxt, planner_context)
        end
    end
end
