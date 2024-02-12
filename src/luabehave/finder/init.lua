local utils = require('luabehave.utils')

local finder_factory = {}

local submodules = {
    ["default"] = require('luabehave.finder.default'),
}

function finder_factory.list(_)
    return utils.get_table_keys(submodules)
end

function finder_factory.get(args)
    return utils.get_submodule(args, "finder", submodules, "default")
end

return finder_factory
