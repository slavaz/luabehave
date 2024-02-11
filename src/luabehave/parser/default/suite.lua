local suite = {}

local parser_utils = require "luabehave.parser.default.utils"
local utils = require "luabehave.utils"


local RET_VALUES = parser_utils.RET_VALUES

function suite.parse(context, line)
    if context.story.name then
        return RET_VALUES.FAILURE, ("'%s' allowed only at the begining of a file"):format(context.keywords.suite)
    end
    local a_keyword = context.keywords.suite
    context.story.suites = utils.split_by_comma(line:sub(#a_keyword + 1))
    return RET_VALUES.SUCCESS
end

return suite
