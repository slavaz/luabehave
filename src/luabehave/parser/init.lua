local utils = require('luabehave.utils')

local parser_factory = {}

local submodules = {
    ["default"] = require('luabehave.parser.default'),
}

function parser_factory.list(_)
    return utils.get_table_keys(submodules)
end

function parser_factory.get(args)
    return utils.get_submodule(args, "parser", submodules, "default")
end

return parser_factory
