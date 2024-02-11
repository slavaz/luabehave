local function get(acxt)
    return {
        suite                 = "Suite: ",
        story                 = "Story: ",
        story_background      = "Background:",
        scenario              = "Scenario: ",
        before_step           = "Given ",
        action_step           = "When ",
        after_step            = "Then ",
        and_step              = "And ",
        scenario_parametrized = "Examples:",

        table_name            = "~|",
        table_header          = "!|",
        table_row             = "|",

        comments              = { "#", "--" },
        escape                = "\\",
        spaces                = { " ", "\t" },
        open_bracket          = "{",
        close_bracket         = "}",
        equal                 = "=",
    }
end

local default_keywords = {
    name = function() return 'default' end,
    help = require('luabehave.keywords.default.help'),

    get = get,

}



return default_keywords
