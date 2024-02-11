local utils = require('luabehave.utils')
local scenario = require('luabehave.planner.default.scenario')
local parse_steps = require('luabehave.planner.default.step')
local make_call = require("luabehave.planner.default.make_call")
local validate_args = require('luabehave.finder.default.args')

local function add_before_story_step(acxt, context)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function(n)
        acxt.output.info("Running story: " .. context_snapshot.story_name)
        if context.step_implementations.before_story then
            return make_call(acxt,
                {
                    context_snapshot = context_snapshot,
                    name = "__before_story",
                    func = context.step_implementations.before_story.func,
                    args = {}
                })
        end
    end)
end

local function add_after_story_step(acxt, context)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function()
        if context.step_implementations.after_story then
            return make_call(acxt,
                {
                    context_snapshot = context_snapshot,
                    name = "__after_story",
                    func = context.step_implementations.after_story.func,
                    args = {}
                })
        end
    end)
end

local function make_background_plan(acxt, context)
    if not context.suite.story.parsed.background then return end
    parse_steps(
        acxt,
        context,
        context.step_implementations["given"],
        context.suite.story.parsed.background
    )
end

local function in_current_suite(context, story, default_suite_name)
    if context.suite.name == default_suite_name then
        return true
    end
    for _, suite in ipairs(story.suites) do
        if suite == context.suite.name then
            return true
        end
    end
    return false
end

return function(acxt, context)
    local args = validate_args(acxt.args)

    for story_path, story in pairs(context.stories) do
        if (in_current_suite(context, story, args["planner.default.suite.name"])) then
            context:init_story(story)
            context.suite.story.path = story_path
            add_before_story_step(acxt, context)
            context.step_type = acxt.keywords.get(acxt).story_background
            make_background_plan(acxt, context, story)
            scenario.make_plan(acxt, context, story)
            context.current_environment = context.suite.story.environment
            add_after_story_step(acxt, context)
            context.current_story = nil
        end
    end
end
