local comments = {}
local utils = require("luabehave.parser.utils")

local RET_VALUES = utils.RET_VALUES

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