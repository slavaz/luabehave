local utils = require('luabehave.utils')

local runner_factory = {}

local submodules = {
    ["default"] = require('luabehave.runner.default'),
}

local function help(args, submodule)
    return
    [[The runner submodule engine is used to run executive plan of stories based on defined steps. You can specify a runner submodule using the [--runner=<submodule>] argument.
To get a list of available submodules, use the --runner-list argument.
The following submodules are currently available:
    default

Selected load submodule: ]]
end

function runner_factory.list(args)
    return utils.get_table_keys(submodules)
end

function runner_factory.get(args)
    return utils.get_submodule(args, "runner", help, submodules, "default")
end

return runner_factory
