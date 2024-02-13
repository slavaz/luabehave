local utils = require('luabehave.utils')
local prepare_scenario_plan = require('luabehave.planner.default.scenario')
local prepare_steps = require('luabehave.planner.default.step')
local validate_args = require('luabehave.planner.default.args')
local has_unimplemented_steps_in = require('luabehave.planner.default.has_unimplemented')

local private = {}
if _G["__tests"] then
    _G["__tests"]["planner_story_private"] = private
end

function private.prepare_before_story_handler(acxt, planner_context)
    local func = planner_context.step_implementations.before_story
        and planner_context.step_implementations.before_story.func or nil
    utils.add_to_table(planner_context.executable_steps, {
        keyword = acxt.keywords.get(acxt).story,
        context_snapshot = planner_context:snapshot(),
        step = {
            name = "__before_story",
            func = func,
            args = {},
        },
    })
end

function private.prepare_after_story_handler(acxt, planner_context)
    local func = planner_context.step_implementations.after_story
        and planner_context.step_implementations.after_story.func or nil
    utils.add_to_table(planner_context.executable_steps, {
        keyword = acxt.keywords.get(acxt).story,
        context_snapshot = planner_context:snapshot(),
        step = {
            name = "__after_story",
            func = func,
            args = {},
        },
    })
end

function private.prepare_background_plan(acxt, planner_context)
    if not planner_context.suite.story.parsed.background then return end
    prepare_steps(
        planner_context,
        planner_context.step_implementations["given"],
        planner_context.suite.story.parsed.background,
        acxt.keywords.get(acxt).story_background
    )
end

function private.in_current_suite(planner_context, parsed_story, default_suite_name)
    if planner_context.suite.name == default_suite_name then
        return true
    end
    for _, suite in ipairs(parsed_story.suites) do
        if suite == planner_context.suite.name then
            return true
        end
    end
    return false
end

function private.has_unimplemented_steps(planner_context, parsed_story)
    if has_unimplemented_steps_in(parsed_story.background,
            planner_context.step_implementations["given"]) then
        return true
    end
    return false
end

function private.prepare_story(acxt, planner_context, args, story_path, parsed_story)
    if not private.in_current_suite(planner_context, parsed_story, args["planner.default.suite.name"]) then
        return
    end
    planner_context:init_story(parsed_story)

    if has_unimplemented_steps_in(parsed_story.background,
            planner_context.step_implementations["given"]) then
        planner_context.suite.story.unimplemented = true
    end

    planner_context.suite.story.path = story_path
    private.prepare_before_story_handler(acxt, planner_context)
    planner_context.step_type = acxt.keywords.get(acxt).story_background
    private.prepare_background_plan(acxt, planner_context)
    prepare_scenario_plan(acxt, planner_context)
    planner_context.current_environment = planner_context.suite.story.environment
    private.prepare_after_story_handler(acxt, planner_context)
    planner_context.current_story = nil
end

return function(acxt, planner_context)
    local args = validate_args(acxt.args)
    for story_path, parsed_story in pairs(planner_context.stories) do
        private.prepare_story(acxt, planner_context, args, story_path, parsed_story)
    end
end
