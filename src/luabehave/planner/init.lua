local utils = require('luabehave.utils')

local planner_factory = {}

local submodules = {
    ["default"] = require('luabehave.planner.default'),
}

function planner_factory.list(_)
    return utils.get_table_keys(submodules)
end

function planner_factory.get(args)
    return utils.get_submodule(args, "planner", submodules, "default")
end

return planner_factory
