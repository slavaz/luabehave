local utils = require('luabehave.utils')

local keywords_factory = {}

local submodules = {
    ["default"] = require('luabehave.keywords.default'),
}

local function help(_)
    return
    [[The keywords submodule loader allows to use different keywors whilr parsing story files. You can specify a keywords submodule using the [--keywords=<submodule>] argument.
To get a list of available submodules, use the --keywords-list argument.
The following submodules are currently available:
    default

Selected keywords submodule: ]]
end

function keywords_factory.list(_)
    return utils.get_table_keys(submodules)
end

function keywords_factory.get(args)
    return utils.get_submodule(args, "keywords", help, submodules, "default")
end

return keywords_factory
