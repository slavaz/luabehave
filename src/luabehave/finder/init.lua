local utils = require('luabehave.utils')

local finder_factory = {}

local submodules = {
    ["default"] = require('luabehave.finder.default'),
}

local function help(_)
    return
    [[The search submodule loader is used to search for stories and step definitions. You can specify a search submodule using the [--finder=<submodule>] argument.
To get a list of available submodules, use the --finder-list argument.
The following submodules are currently available:
    default

Selected search submodule: ]]
end

function finder_factory.list(_)
    return utils.get_table_keys(submodules)
end

function finder_factory.get(args)
    return utils.get_submodule(args, "finder", help, submodules, "default")
end

return finder_factory
