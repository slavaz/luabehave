local keywords = require "luabehave.parser.keywords"
local utils = require "luabehave.parser.utils"
local steps = require "luabehave.parser.steps"
local scenario = require "luabehave.parser.scenario"
local story = require "luabehave.parser.story"
local comments = require "luabehave.parser.comments"
local table_block = require "luabehave.parser.table_block"

local RET_VALUES = utils.RET_VALUES
local STATE = utils.STORY_STATE

local additional_parsers = {
    comments.parse,
    story.parse_description,
}

local function parse_one_line(context, line)
    local lline = utils.trim(line)

    local ret_code, result
    ret_code, result = table_block.parse(context, lline)
    if ret_code ~= RET_VALUES.SKIP then
        return ret_code, result
    end

    for keyword, handler in pairs(context.keywords_map) do
        if utils.startswith(lline, keyword) then
            ret_code, result = handler(context, lline)
            if ret_code ~= RET_VALUES.SKIP then
                return ret_code, result
            end
        end
    end
    for _, handler in ipairs(additional_parsers) do
        ret_code, result = handler(context, line)
        if ret_code ~= RET_VALUES.SKIP then
            return ret_code, result
        end
    end
end

local function parse_story_from_text(context, source)
    local count = 1
    for line in source:gmatch("[^\n]+") do
        local ret_code, result = parse_one_line(context, line)
        if ret_code == RET_VALUES.FAILURE then
            return false, ("%s\nline #%d: '%s'"):format(result, count, line )
        end
        count = count + 1
    end
    return true, context.story
end

local function parse_story_from_table(context, source)
    local count = 1
    for _, line in ipairs(source) do
        local ret_code, result = parse_one_line(context, line)
        if ret_code == RET_VALUES.FAILURE then
            return false, ("%s\nline #%d: '%s'"):format(result, count, line )
        end
        count = count + 1
    end
    return true, context.story
end

local function parse_story_from_file(context, source)
    local count = 1
    for line in source:lines() do
        local ret_code, result = parse_one_line(context, line)
        if ret_code == RET_VALUES.FAILURE then
            return false, ("%s\nline #%d: '%s'"):format(result, count, line )
        end
        count = count + 1
    end
    return true, context.story
end

local function validate_story(context)
    if utils.is_table_empty(context.story.scenarios) then
        return false, "A Story has no scenarios"
    end
    return true, context.story
end
local function get_keywords_map(input_keywords)
    local lkeywords = input_keywords or keywords.get_default()
    local ret_value, result = keywords.validate(lkeywords)
    if not ret_value then
        return false, result
    end

    local keywords_map = {
        [lkeywords.story] = story.parse,
        [lkeywords.story_background] = story.parse_background,
        [lkeywords.scenario] = scenario.parse,
        [lkeywords.before_step] = steps.parse_given,
        [lkeywords.action_step] = steps.parse_when,
        [lkeywords.after_step] = steps.parse_then,
        [lkeywords.and_step] = steps.parse_and,
        [lkeywords.scenario_parametrized] = scenario.parse_examples,
    }
    return true, keywords_map, lkeywords
end

local function parse_story(source, input_keywords)
    local ret_value, keywords_map, lkeywords = get_keywords_map(input_keywords)
    if not ret_value then
        return false, keywords_map
    end

    local context = {
        keywords = lkeywords,
        keywords_map = keywords_map,

        story = {
            description = {},
            background = nil,
            scenarios = {},
        },
        current_scenario = nil,
        current_steps = nil,
        current_step = nil,
        state = STATE.STORY,
        table = {},
    }

    local source_type_handlers = {
        string = parse_story_from_text,
        table = parse_story_from_table,
        userdata = parse_story_from_file,
    }

    local ret_value, result
    local source_handler_found = false
    for source_type, handler in pairs(source_type_handlers) do
        if type(source) == source_type then
            source_handler_found = true
            ret_value, result = handler(context, source)
            if not ret_value then
                return ret_value, result
            end
            break
        end
    end
    if not source_handler_found then
        return false, "Invalid source type: " .. type(source)
    end
    return validate_story(context)
end

return parse_story
