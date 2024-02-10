local table_block = {}

local utils = require "luabehave.parser.default.utils"
local table_parser = require "luabehave.parser.default.table"
local is_table_empty = require "luabehave.utils".is_table_empty

local RET_VALUES = utils.RET_VALUES
local STATE = utils.STORY_STATE

function table_block.parse(context, line)
    local line = utils.trim(line)

    if not (context.state == STATE.SCENARIO_EXAMPLES  or
        context.state == STATE.SCENARIO or
        context.state == STATE.BACKGROUND) then
        return RET_VALUES.SKIP
    end
    local ret_code, result = table_parser.parse(context.table, line, context.keywords)
    if ret_code == RET_VALUES.SUCCESS then
        return RET_VALUES.SUCCESS
    end
    if ret_code ~= RET_VALUES.LINE_VALIDATION_ERROR then
        return RET_VALUES.FAILURE, result
    end
    if is_table_empty(context.table) then
        return RET_VALUES.SKIP
    end
    if context.state == STATE.SCENARIO_EXAMPLES then
        context.current_scenario.examples = table_parser.get(context.table)
        context.table = {}
        return RET_VALUES.SKIP
    end
    if not context.current_step then
        return RET_VALUES.FAILURE, ("Table outside of '%s', '%s' or '%s' step")
            :format(context.keywords.before_step, context.keywords.action_step, context.keywords.after_step)
    end
    if not context.current_step.args then
        context.current_step.args = {}
    end
    for key, value in pairs(table_parser.get(context.table)) do
        context.current_step.args[key] = value
    end
    context.table = {}
    return RET_VALUES.SKIP
end

return table_block
