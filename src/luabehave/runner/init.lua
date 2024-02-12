local utils = require('luabehave.utils')

local runner_factory = {}

local submodules = {
    ["default"] = require('luabehave.runner.default'),
}

function runner_factory.list(_)
    return utils.get_table_keys(submodules)
end

function runner_factory.get(args)
    return utils.get_submodule(args, "runner", submodules, "default")
end

return runner_factory
