local comments = {}
local parser_utils = require("luabehave.parser.default.utils")
local utils = require("luabehave.utils")

local RET_VALUES = parser_utils.RET_VALUES

function comments.parse(context, line)
    local line = utils.trim(line)
    for _, comment in ipairs(context.keywords.comments) do
        if utils.startswith(line, comment) then
            return RET_VALUES.SUCCESS
        end
    end
    return RET_VALUES.SKIP
end

return comments