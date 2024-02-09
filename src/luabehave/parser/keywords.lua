local default_keywords = {
    story                = "Story: ",
    story_background     = "Background:",
    feature              = "Scenario: ",
    before_step          = "Given ",
    action_step          = "When ",
    after_step           = "Then ",
    and_step             = "And ",
    feature_parametrized = "Examples:",

    table_name           = "~|",
    table_header         = "!|",
    table_row            = "|",

    comments             = { "#", "--" },
    escape               = "\\",
    spaces               = { " ", "\t" },
    open_bracket         = "{",
    close_bracket        = "}",
    equal                = "=",
}

local function keywords_validate(keywords)
    if keywords == nil then
        return true, default_keywords
    end
    if type(keywords) ~= "table" then
        return false, "Keywords should be a table"
    end
    for k, v in pairs(default_keywords) do
        if keywords[k] == nil then
            return false, ("Keyword '%s' is missing"):format(k)
        end
    end
    if type(keywords.comments) ~= "table" then
        return false, "Comments should be a table"
    end
    if #keywords.comments == 0 then
        return false, "Comments should not be empty"
    end
    for _, comment in ipairs(keywords.comments) do
        if type(comment) ~= "string" then
            return false, "Comments should be strings"
        end
    end
    if type(keywords.spaces) ~= "table" then
        return false, "Spaces should be a table"
    end
    if #keywords.spaces == 0 then
        return false, "Spaces should not be empty"
    end
    for _, space in ipairs(keywords.spaces) do
        if type(space) ~= "string" then
            return false, "Spaces should be strings"
        end
    end
    return true, keywords
end

return {
    validate = keywords_validate,
    get_default = function() return default_keywords end
}
