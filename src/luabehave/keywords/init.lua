local utils = require('luabehave.utils')

local keywords_factory = {}

local submodules = {
    ["default"] = require('luabehave.keywords.default'),
}

function keywords_factory.list(_)
    return utils.get_table_keys(submodules)
end

function keywords_factory.get(args)
    return utils.get_submodule(args, "keywords", submodules, "default")
end

return keywords_factory
