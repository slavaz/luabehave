local utils = require('luabehave.utils')

local loader_factory = {}

local submodules = {
    ["default"] = require('luabehave.loader.default'),
}

function loader_factory.list(_)
    return utils.get_table_keys(submodules)
end

function loader_factory.get(args)
    return utils.get_submodule(args, "loader", submodules, "default")
end

return loader_factory
