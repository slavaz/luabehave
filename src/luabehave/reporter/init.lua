local utils = require('luabehave.utils')

local runner_factory = {}

local submodules = {
    ["default"] = require('luabehave.reporter.default'),
}

local function help(args, submodule)
    return
    [[The reporter submodule engine is used for collecting info about running steps and for sgowing ststictic You can specify a reporter submodule using the [--reporter=<submodule>] argument.
To get a list of available submodules, use the --reporter-list argument.
The following submodules are currently available:
    default

Selected reporter submodule: ]]
end

function runner_factory.list(args)
    return utils.get_table_keys(submodules)
end

function runner_factory.get(args)
    return utils.get_submodule(args, "reporter", help, submodules, "default")
end

return runner_factory
