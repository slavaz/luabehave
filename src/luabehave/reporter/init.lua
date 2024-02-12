local utils = require('luabehave.utils')

local runner_factory = {}

local submodules = {
    ["default"] = require('luabehave.reporter.default'),
}

function runner_factory.list(args)
    return utils.get_table_keys(submodules)
end

function runner_factory.get(args)
    return utils.get_submodule(args, "reporter", submodules, "default")
end

return runner_factory
