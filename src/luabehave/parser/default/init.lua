local parser_utils = require "luabehave.parser.default.utils"
local steps = require "luabehave.parser.default.steps"
local scenario = require "luabehave.parser.default.scenario"
local story = require "luabehave.parser.default.story"
local suite = require "luabehave.parser.default.suite"
local comments = require "luabehave.parser.default.comments"
local table_block = require "luabehave.parser.default.table_block"
local utils = require "luabehave.utils"
local table_parser = require "luabehave.parser.default.table"

local is_table_empty = utils.is_table_empty

local RET_VALUES = parser_utils.RET_VALUES
local STATE = parser_utils.STORY_STATE

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
            return false, ("%s\nline #%d: '%s'"):format(result, count, line)
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
            return false, ("%s\nline #%d: '%s'"):format(result, count, line)
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
            return false, ("%s\nline #%d: '%s'"):format(result, count, line)
        end
        count = count + 1
    end
    return true, context.story
end

local function validate_story(context)
    if is_table_empty(context.story.scenarios) then
        return false, "A Story has no scenarios"
    end
    return true, context.story
end
local function finalize_story(context)
    if context.state == STATE.SCENARIO_EXAMPLES then
        context.current_scenario.examples = table_parser.get(context.table)
        context.table = {}
    end
    return RET_VALUES.SUCCESS
end
local function get_keywords_map(input_keywords)

    local keywords_map = {
        [input_keywords.suite] = suite.parse,
        [input_keywords.story] = story.parse,
        [input_keywords.story_background] = story.parse_background,
        [input_keywords.scenario] = scenario.parse,
        [input_keywords.before_step] = steps.parse_given,
        [input_keywords.action_step] = steps.parse_when,
        [input_keywords.after_step] = steps.parse_then,
        [input_keywords.and_step] = steps.parse_and,
        [input_keywords.scenario_parametrized] = scenario.parse_examples,
    }
    return true, keywords_map
end

local function parse_story(acxt, source)
    local lkeywords = acxt.keywords.get()
    local ret_value, keywords_map = get_keywords_map(lkeywords)
    if not ret_value then
        return false, keywords_map
    end

    local context = {
        keywords = lkeywords,
        keywords_map = keywords_map,

        story = {
            suites = {},
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
    ret_value, result = finalize_story(context)
    if not ret_value then
        return ret_value, result
    end
    return validate_story(context)
end

local parser = {
    name = function() return 'default' end,
    help = require('luabehave.parser.default.help'),

    parse = parse_story,
}

return parser
