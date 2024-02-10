local utils = require('luabehave.utils')

local parser_factory = {}

local submodules = {
    ["default"] = require('luabehave.parser.default'),
}

local function help(_)
    return
    [[The parser submodule engine is used to parse story files. You can specify a parser submodule using the [--parser=<submodule>] argument.
To get a list of available submodules, use the --parser-list argument.
The following submodules are currently available:
    default

Selected parser submodule: ]]
end

function parser_factory.list(_)
    return utils.get_table_keys(submodules)
end

function parser_factory.get(args)
    return utils.get_submodule(args, "parser", help, submodules, "default")
end

return parser_factory
