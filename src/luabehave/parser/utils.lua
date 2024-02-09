local utils = {}

utils.RET_VALUES = {
    SUCCESS = 1,
    FAILURE = 2,
    SKIP = 3,
    PARSE_ERROR = 4,
    VALIDATION_ERROR = 5,
    LINE_VALIDATION_ERROR = 6,
}

utils.STORY_STATE = {
    STORY = 1,
    BACKGROUND = 2,
    SCENARIO = 4,
    SCENARIO_EXAMPLES = 8,
}

function utils.trim(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

function utils.startswith(s, prefix)
    return s:sub(1, #prefix) == prefix
end

function utils.add_to_table(table, element)
    table[#table + 1] = element
end

function utils.is_table_empty(tbl)
    return next(tbl) == nil
end

return utils
