local utils = require "luabehave.parser.default.utils"

local suite = {}

local RET_VALUES = utils.RET_VALUES

local function split_by_comma(line)
    local result = {}
    for word in line:gmatch("[^,]+") do
        result[#result + 1] = utils.trim(word)
    end
    return result
end

function suite.parse(context, line)
    if context.story.name then
        return RET_VALUES.FAILURE, ("'%s' allowed only at the begining of a file"):format(context.keywords.suite)
    end
    local a_keyword = context.keywords.suite
    context.story.suites = split_by_comma(line:sub(#a_keyword + 1))
    return RET_VALUES.SUCCESS
end

return suite
