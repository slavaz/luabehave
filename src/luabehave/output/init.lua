local utils = require('luabehave.utils')

local output_factory = {}

local submodules = {
    ["default"] = require('luabehave.output.default'),
}

local function help(_)
    return
    [[The output submodule engine is used to make output of stories execution results. You can specify a load submodule using the [--output=<submodule>] argument.
To get a list of available submodules, use the --output-list argument.
The following submodules are currently available:
    default

Selected output submodule: ]]
end

function output_factory.list(_)
    return utils.get_table_keys(submodules)
end

function output_factory.get(args)
    return utils.get_submodule(args, "output", help, submodules, "default")
end

return output_factory
