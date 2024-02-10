local validate_args = require('luabehave.finder.default.args')
local recursive_search = require('luabehave.finder.default.recursive')

return function(application_context)
    local args = validate_args(application_context.args)
    local step_extention = args["finder.default.step.extention"]
    local step_path = args["finder.default.step.path"]

    return recursive_search(application_context, step_path, step_extention)
end
