local utils = require('luabehave.utils')
local validate_args = require('luabehave.planner.default.args')

local function get_suites_from_args(acxt)
    local args = validate_args(acxt.args)
    return utils.split_by_comma(args["planner.default.suites"])
end

local function get_suites_from_stories(context)
    local suites = {}
    for _, story in pairs(context.stories) do
        for _, suite in ipairs(story.suites) do
            suites[suite] = true
        end
    end
    return suites
end

return function(acxt, context)
    local suites_from_args = get_suites_from_args(acxt)
    local suites_from_stories = get_suites_from_stories(context)
    if #suites_from_args == 0 then
        return { acxt.args["planner.default.suite.name"] }
    end
    local suites = utils.table_intersection(utils.get_table_values(suites_from_args), suites_from_stories)
    return utils.get_table_keys(suites)
end
