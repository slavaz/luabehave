local utils = require('luabehave.utils')

local output_factory = {}

local submodules = {
    ["default"] = require('luabehave.output.default'),
}

function output_factory.list(_)
    return utils.get_table_keys(submodules)
end

function output_factory.get(args)
    return utils.get_submodule(args, "output", submodules, "default")
end

return output_factory
