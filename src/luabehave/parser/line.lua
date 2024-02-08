
local STATE = {}

local function add_char(parsed_line, char)
    parsed_line[#parsed_line+1] = char
end

local function unexpected_symbol(char)
    return false, ("Unexpected symbol '%s'"):format(char)
end

local function parse_outside_regular(context, char, keywords)
    if char == keywords.open_bracket then
        context.state = STATE.INSIDE.NAME
        add_char(context.parsed_line, char)
        return true
    end
    if char == keywords.close_bracket then
        return unexpected_symbol(keywords.close_bracket)
    end
    if char == keywords.escape then
        context.state = STATE.OUTSIDE.ESCAPE
        return true
    end
    add_char(context.parsed_line, char)
    return true
end

local function parse_outside_escape(context, char, keywords)
    add_char(context.parsed_line, char)
    context.state = STATE.OUTSIDE.REGULAR
    return true
end

local function parse_inside_name(context, char, keywords)
    if char == keywords.escape then
        context.state = STATE.INSIDE.NAME_ESCAPE
        return true
    end
    for _, space in ipairs(keywords.spaces) do
        if char == space then
            return true
        end
    end
    if char == keywords.close_bracket then
        context.state = STATE.OUTSIDE.REGULAR
        add_char(context.parsed_line, char)
        context.name = table.concat(context.buffer)
        context.args[context.name] = ""
        context.buffer = {}
        return true
    end
    if char == keywords.open_bracket then
        return unexpected_symbol(keywords.open_bracket)
    end
    if char == keywords.equal then
        context.state = STATE.INSIDE.VALUE
        context.name = table.concat(context.buffer)
        context.buffer = {}
        return true
    end
    add_char(context.buffer, char)
    add_char(context.parsed_line, char)
    return true
end

local function parse_inside_name_escape(context, char, keywords)
    add_char(context.buffer, char)
    add_char(context.parsed_line, char)
    context.state = STATE.INSIDE.NAME
    return true
end

local function parse_inside_value(context, char, keywords)
    if char == keywords.escape then
        context.state = STATE.INSIDE.VALUE_ESCAPE
        return true
    end
    if char == keywords.open_bracket then
        return unexpected_symbol(keywords.open_bracket)
    end
    if char == keywords.close_bracket then
        context.state = STATE.OUTSIDE.REGULAR
        context.args[context.name] = table.concat(context.buffer)
        context.buffer = {}
        add_char(context.parsed_line, char)
        return true
    end
    add_char(context.buffer, char)
    return true
end

local function parse_inside_value_escape(context, char, keywords)
    add_char(context.buffer, char)
    context.state = STATE.INSIDE.VALUE
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

    local context = {
        state = STATE.OUTSIDE.REGULAR,
        buffer = {},
        name = "",
        parsed_line = {},
        args = {},
    }

    for i = 1, #line do
        local parser_result, error_string = context.state(context, line:sub(i, i), keywords)
        if not parser_result then
            return false, ("Failed to parse at position %d: %s"):format(i, error_string)
        end
    end

    if context.state ~= STATE.OUTSIDE.REGULAR then
        return false, "Unexpected end of line. Check the closing parentheses."
    end

    return true, {
        name = table.concat(context.parsed_line),
        args = context.args,
    }
end

return parse_line
