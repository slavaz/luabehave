local story = {}
local utils = require("luabehave.parser.default.utils")
local add_to_table = require("luabehave.utils").add_to_table

local RET_VALUES = utils.RET_VALUES
local STATE = utils.STORY_STATE

function story.parse_description(context, line)
    if context.state == STATE.STORY then
        add_to_table(context.story.description, line)
        return RET_VALUES.SUCCESS
    end
    return RET_VALUES.SKIP
end

function story.parse(context, line)
    if context.story.name then
        return RET_VALUES.FAILURE, ("'%s' not allowed multiple times"):format(context.keywords.story)
    end
    local a_keyword = context.keywords.story
    context.story.name = line:sub(#a_keyword + 1)
    return RET_VALUES.SUCCESS
end

function story.parse_background(context, line)
    if context.current_scenario then
        return RET_VALUES.FAILURE, ("'%s' after scenario"):format(context.keywords.story_background)
    end
    if context.story.background then
        return RET_VALUES.FAILURE, ("'%s' is not allowed multiple times"):format(context.keywords.story_background)
    end
    context.state = STATE.BACKGROUND
    context.story.background = {}
    context.current_steps = context.story.background
    return RET_VALUES.SUCCESS
end

return story
