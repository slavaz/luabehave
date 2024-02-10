local utils = require("luabehave.parser.default.utils")
local add_to_table = require("luabehave.utils").add_to_table

local STATE

local function parse_inside(context, char, lkeywords)
    if char == lkeywords.escape then
        context.state = STATE.INSIDE_ESCAPE
        return true
    end
    if char == lkeywords.table_row then
        context.state = STATE.INSIDE
        context.args[#context.args + 1] = table.concat(context.buffer)
        context.buffer = {}
        return true
    end
    add_to_table(context.buffer, char)
    return true
end

local function parse_delimiter(context, char, lkeywords)
    if char == lkeywords.table_row then
        context.state = STATE.INSIDE
        return true
    end
    return false, "Expected delimiter"
end

local function parse_inside_escape(context, char, lkeywords)
    add_to_table(context.buffer, char)
    context.state = STATE.INSIDE
    return true
end

STATE = {
    DELIMITER = parse_delimiter,
    INSIDE = parse_inside,
    INSIDE_ESCAPE = parse_inside_escape,
}

local function parse_table_line(line, lkeywords)
    local context = {
        state = STATE.DELIMITER,
        buffer = {},
        args = {},
    }
    for i = 1, #line do
        local parser_result, error_string = context.state(context, line:sub(i, i), lkeywords)
        if not parser_result then
            return false, ("Failed to parse at position %d: %s"):format(i, error_string)
        end
    end

    if context.state ~= STATE.INSIDE or #context.buffer > 0 then
        return false, "Unexpected end of line. Check the closing delimiter."
    end
    return true, context.args
end

return parse_table_line
