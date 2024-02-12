local parse_table_line = require("luabehave.parser.default.table_line")
local parser_utils = require("luabehave.parser.default.utils")
local utils = require("luabehave.utils")

local RET_VALUES = parser_utils.RET_VALUES

local function parse_comments(_, line, lkeywords)
    local lline = utils.trim(line)
    for _, comment in ipairs(lkeywords.comments) do
        if utils.startswith(lline, comment) then
            return RET_VALUES.SUCCESS
        end
    end
    return RET_VALUES.SKIP
end

local function table_name_handler(table_context, line, keyword, keywords)
    if table_context.name then
        return RET_VALUES.VALIDATION_ERROR, "Only one table name definition is allowed."
    end
    local ret_value, result = parse_table_line(line:sub(#keyword), keywords)
    if not ret_value then
        return RET_VALUES.PARSE_ERROR, result
    end
    if #result > 1 then
        return RET_VALUES.VALIDATION_ERROR, "Only one table name in the row is allowed."
    end
    table_context.name = result[1]
    table_context.parsing_started = true
    return RET_VALUES.SUCCESS
end
local function table_header_handler(table_context, line, keyword, keywords)
    if table_context.headers then
        return RET_VALUES.VALIDATION_ERROR, "Only one table header definition is allowed."
    end
    if #table_context.rows ~= 0 then
        return RET_VALUES.VALIDATION_ERROR, "Table header should be defined before any rows."
    end

    local ret_value, result = parse_table_line(line:sub(#keyword), keywords)
    if not ret_value then
        return RET_VALUES.PARSE_ERROR, result
    end
    table_context.headers = result
    table_context.parsing_started = true
    return RET_VALUES.SUCCESS
end

local function table_row_handler(table_context, line, keyword, keywords)
    local ret_value, result = parse_table_line(line:sub(#keyword), keywords)
    if not ret_value then
        return RET_VALUES.PARSE_ERROR, result
    end
    table_context.rows[#table_context.rows + 1] = result
    table_context.parsing_started = true
    return RET_VALUES.SUCCESS
end

local function validate_line(table_context, line, keywords)
    local table_keywords = {
        keywords.table_name,
        keywords.table_header,
        keywords.table_row,
    }
    if table_context.parsing_started then
        for _, comment in ipairs(keywords.comments) do
            table_keywords[#table_keywords + 1] = comment
        end
    end
    local validated = RET_VALUES.LINE_VALIDATION_ERROR
    local result = "Line does not start with any of the table keywords."
    for _, keyword in pairs(table_keywords) do
        if utils.startswith(line, keyword) then
            validated = RET_VALUES.SUCCESS
            result = ''
            break
        end
    end
    return validated, result
end

local function parse_table(table_context, line, keywords)
    local keywords_map = {
        [keywords.table_name] = table_name_handler,
        [keywords.table_header] = table_header_handler,
        [keywords.table_row] = table_row_handler ,
    }
    local ret_value, result
    local lline = utils.trim(line)
    ret_value, result = validate_line(table_context, lline, keywords)
    if ret_value ~= RET_VALUES.SUCCESS then
        return ret_value, result
    end

    lline = utils.trim(lline)
    if not table_context.initialized then
        table_context.initialized = true
        table_context.parsing_started = false
        table_context.name = nil
        table_context.headers = nil
        table_context.rows = {}
    end

    ret_value, result = parse_comments(table_context, lline, keywords)
    if ret_value ~= RET_VALUES.SKIP then
        return ret_value, result
    end

    for keyword, handler in pairs(keywords_map) do
        if utils.startswith(lline, keyword) then
            ret_value, result = handler(table_context, lline, keyword, keywords)
            if ret_value ~= RET_VALUES.SKIP then
                return ret_value, result
            end
        end
    end
    return RET_VALUES.SUCCESS
end

local function get_table_from_context(table_context)
    table_context.rows = table_context.rows or {}
    local ret_value = {}
    local current_table = ret_value

    if table_context.name then
        ret_value[table_context.name] = {}
        current_table = ret_value[table_context.name]
    end
    if not table_context.headers then
        if #table_context.rows == 1 then
            for i, row in ipairs(table_context.rows[1]) do
                current_table[i] = row
            end
            return ret_value
        end
        for i, row in ipairs(table_context.rows) do
            current_table[i] = row
        end
        return ret_value
    end
    if #table_context.rows == 0 then
        for _, header in ipairs(table_context.headers) do
            current_table[header] = {}
        end
        return ret_value
    end

    local function init_map_table(table, headers, rows)
        local i = 1
        while i <= #headers do
            table[headers[i]] = rows[i]
            i = i + 1
        end
        for i1 = i, #rows do
            table[#table+1] = rows[i1]
        end

    end

    if #table_context.rows == 1 then
        init_map_table(current_table, table_context.headers, table_context.rows[1])
        return ret_value
    end

    for row_index, row in ipairs(table_context.rows) do
        local new_table = {}
        init_map_table(new_table, table_context.headers, row)
        current_table[row_index] = new_table
    end

    return ret_value
end

return {
    parse = parse_table,
    get = get_table_from_context,
}
