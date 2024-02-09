local steps = {}
local parse_line = require "luabehave.parser.line"
local utils = require "luabehave.parser.utils"

local RET_VALUES = utils.RET_VALUES
local STATE = utils.STORY_STATE

local function then_when_callback(context, line, args)
    if context.state ~= STATE.SCENARIO then
        return RET_VALUES.FAILURE, ("'%s' outside '%s' isn't allowed"):format(
            args.keyword_step_name, context.keywords.scenario)
    end
    return RET_VALUES.SUCCESS
end

local function given_callback(context, line, args)
    if context.state == STATE.SCENARIO_EXAMPLES then
        return RET_VALUES.FAILURE, ("'%s' inside '%s' isn't not allowed"):format(
            args.keyword_step_name, context.keywords.examples)
    end
    return RET_VALUES.SUCCESS
end

local function and_callback(context, line, args)
    if context.state == STATE.SCENARIO_EXAMPLES then
        return RET_VALUES.FAILURE, ("'%s' inside '%s' isn't not allowed"):format(
            args.keyword_step_name, context.keywords.examples)
    end
    if not context.current_steps or utils.is_table_empty(context.current_steps) then
        return RET_VALUES.FAILURE, ("'%s' without previous '%s', '%s' or '%s'"):format(
            args.keyword_step_name, context.keywords.before_step, context.keywords.action_step,
            context.keywords.after_step
        )
    end
    return RET_VALUES.SUCCESS
end
local function parse_step(context, line, args)
    if context.state == STATE.STORY then return RET_VALUES.SKIP end

    local ret_value, result = args.check_environtent_callback(context, line, args)

    if ret_value ~= RET_VALUES.SUCCESS then return ret_value, result end
    if context.state == STATE.SCENARIO then context.current_steps = args.scenario_steps_table end

    local a_keyword = args.keyword_step_name
    local ret_value, result = parse_line(line:sub(#a_keyword + 1), context.keywords)
    if not ret_value then return ret_value, result end
    context.current_step = result
    utils.add_to_table(context.current_steps, context.current_step)
    return RET_VALUES.SUCCESS
end

function steps.parse_given(context, line, args)
    local args = {
        keyword_step_name = context.keywords.before_step,
        check_environtent_callback = given_callback,

        scenario_steps_table = context.state == STATE.SCENARIO
            and context.current_scenario.given_steps
            or context.story.background
    }

    return parse_step(context, line, args)
end

function steps.parse_when(context, line)
    local args = {
        keyword_step_name = context.keywords.action_step,
        check_environtent_callback = then_when_callback,
        scenario_steps_table = context.current_scenario and context.current_scenario.when_steps or {}
    }
    return parse_step(context, line, args)
end

function steps.parse_then(context, line)
    local args = {
        keyword_step_name = context.keywords.after_step,
        check_environtent_callback = then_when_callback,
        scenario_steps_table = context.current_scenario and context.current_scenario.then_steps or {}
    }
    return parse_step(context, line, args)
end

function steps.parse_and(context, line)
    local args = {
        keyword_step_name = context.keywords.and_step,
        check_environtent_callback = and_callback,
        scenario_steps_table = context.current_steps
    }

    return parse_step(context, line, args)
end

return steps
