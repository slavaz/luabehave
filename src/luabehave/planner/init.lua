local utils = require('luabehave.utils')

local planner_factory = {}

local submodules = {
    ["default"] = require('luabehave.planner.default'),
}

local function help(_)
    return
    [[The planner submodule engine is used to make executive plan of stories based on defined steps. You can specify a load submodule using the [--planner=<submodule>] argument.
To get a list of available submodules, use the --planner-list argument.
The following submodules are currently available:
    default

Selected planner submodule: ]]
end

function planner_factory.list(_)
    return utils.get_table_keys(submodules)
end

function planner_factory.get(args)
    return utils.get_submodule(args, "planner", help, submodules, "default")
end

return planner_factory
