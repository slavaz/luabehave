local utils = require('luabehave.utils')

local loader_factory = {}

local submodules = {
    ["default"] = require('luabehave.loader.default'),
}

local function help(_)
    return
    [[The loader submodule engine is used to load content of stories and step definitions. You can specify a loader submodule using the [--loader=<submodule>] argument.
To get a list of available submodules, use the --loader-list argument.
The following submodules are currently available:
    default

Selected loader submodule: ]]
end

function loader_factory.list(_)
    return utils.get_table_keys(submodules)
end

function loader_factory.get(args)
    return utils.get_submodule(args, "loader", help, submodules, "default")
end

return loader_factory
