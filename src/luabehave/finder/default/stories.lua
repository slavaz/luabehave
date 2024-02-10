local validate_args = require('luabehave.finder.default.args')
local recursive_search = require('luabehave.finder.default.recursive')

return function(application_context)
    local args = validate_args(application_context.args)
    local story_extention = args["finder.default.story.extention"]
    local story_path = args["finder.default.story.path"]

    return recursive_search(application_context, story_path, story_extention)
end
