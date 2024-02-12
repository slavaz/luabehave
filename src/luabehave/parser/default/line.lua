local add_to_table = require("luabehave.utils").add_to_table
local STATE = {}

local function unexpected_symbol(char)
    return false, ("Unexpected symbol '%s'"):format(char)
end

local function parse_outside_regular(line_context, char)
    if char == line_context.keywords.open_bracket then
        line_context.state = STATE.INSIDE.NAME
        add_to_table(line_context.parsed_line, char)
        return true
    end
    if char == line_context.keywords.close_bracket then
        return unexpected_symbol(line_context.keywords.close_bracket)
    end
    if char == line_context.keywords.escape then
        line_context.state = STATE.OUTSIDE.ESCAPE
        return true
    end
    add_to_table(line_context.parsed_line, char)
    return true
end

local function parse_outside_escape(line_context, char)
    add_to_table(line_context.parsed_line, char)
    line_context.state = STATE.OUTSIDE.REGULAR
    return true
end

local function parse_inside_name(line_context, char)
    if char == line_context.keywords.escape then
        line_context.state = STATE.INSIDE.NAME_ESCAPE
        return true
    end
    for _, space in ipairs(line_context.keywords.spaces) do
        if char == space then
            return true
        end
    end
    if char == line_context.keywords.close_bracket then
        line_context.state = STATE.OUTSIDE.REGULAR
        add_to_table(line_context.parsed_line, char)
        line_context.name = table.concat(line_context.buffer)
        line_context.args[line_context.name] = ""
        line_context.buffer = {}
        return true
    end
    if char == line_context.keywords.open_bracket then
        return unexpected_symbol(line_context.keywords.open_bracket)
    end
    if char == line_context.keywords.equal then
        line_context.state = STATE.INSIDE.VALUE
        line_context.name = table.concat(line_context.buffer)
        line_context.buffer = {}
        return true
    end
    add_to_table(line_context.buffer, char)
    add_to_table(line_context.parsed_line, char)
    return true
end

local function parse_inside_name_escape(line_context, char)
    add_to_table(line_context.buffer, char)
    add_to_table(line_context.parsed_line, char)
    line_context.state = STATE.INSIDE.NAME
    return true
end

local function parse_inside_value(line_context, char)
    if char == line_context.keywords.escape then
        line_context.state = STATE.INSIDE.VALUE_ESCAPE
        return true
    end
    if char == line_context.keywords.open_bracket then
        return unexpected_symbol(line_context.keywords.open_bracket)
    end
    if char == line_context.keywords.close_bracket then
        line_context.state = STATE.OUTSIDE.REGULAR
        line_context.args[line_context.name] = table.concat(line_context.buffer)
        line_context.buffer = {}
        add_to_table(line_context.parsed_line, char)
        return true
    end
    add_to_table(line_context.buffer, char)
    return true
end

local function parse_inside_value_escape(line_context, char)
    add_to_table(line_context.buffer, char)
    line_context.state = STATE.INSIDE.VALUE
    return true
end

STATE = {
    OUTSIDE = {
        REGULAR = parse_outside_regular,
        ESCAPE = parse_outside_escape,
    },
    INSIDE = {
        NAME = parse_inside_name,
        NAME_ESCAPE = parse_inside_name_escape,
        VALUE = parse_inside_value,
        VALUE_ESCAPE = parse_inside_value_escape,
    },
}

local function parse_line(line, keywords)

    local line_context = {
        keywords = keywords or {},
        state = STATE.OUTSIDE.REGULAR,
        buffer = {},
        name = "",
        parsed_line = {},
        args = {},
    }

    for i = 1, #line do
        local parser_result, error_string = line_context.state(line_context, line:sub(i, i))
        if not parser_result then
            return false, ("Failed to parse at position %d: %s"):format(i, error_string)
        end
    end

    if line_context.state ~= STATE.OUTSIDE.REGULAR then
        return false, "Unexpected end of line. Check the closing parentheses."
    end

    return true, {
        name = table.concat(line_context.parsed_line),
        args = line_context.args,
    }
end

return parse_line
