local scenario = {}
local utils = require("luabehave.parser.utils")

local RET_VALUES = utils.RET_VALUES
local STATE = utils.STORY_STATE

function scenario.parse(context, line)
    context.state = STATE.SCENARIO
    local a_keyword = context.keywords.scenario
    context.current_scenario = {
        name = utils.trim(line:sub(#a_keyword + 1)),
        given_steps = {},
        when_steps = {},
        then_steps = {},
        examples = nil,
    }
    utils.add_to_table(context.story.scenarios, context.current_scenario)
    context.current_steps = nil
    context.current_step = nil
    return RET_VALUES.SUCCESS
end

function scenario.parse_examples(context, line)
    if context.state == STATE.SCENARIO_EXAMPLES then
        return RET_VALUES.FAILURE, ("Only one set of '%s' is allowed per '%s'")
            :format(context.keywords.scenario_parametrized, context.keywords.scenario)
    end
    if context.state ~= STATE.SCENARIO then
        return RET_VALUES.FAILURE,
            ("'%s' must be defined inside a '%s'"):format(context.keywords.scenario_parametrized,
                context.keywords.scenario)
    end
    if utils.is_table_empty(context.current_scenario.then_steps) then
        return RET_VALUES.FAILURE, ("'%s' must be defined after at least one '%s' step")
            :format(context.keywords.scenario_parametrized, context.keywords.after_step)
    end
    context.state = STATE.SCENARIO_EXAMPLES
    context.current_scenario.examples = {}
    return RET_VALUES.SUCCESS
end

return scenario
