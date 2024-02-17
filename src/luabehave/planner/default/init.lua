local ContextClass = require('luabehave.planner.default.context')
local prepare_suites_plan = require('luabehave.planner.default.suite')

local default_planner = {
    name = function() return 'default' end,

    prepare_plan = function(acxt, stories, step_implementations)
        local context_obj = ContextClass(acxt, stories, step_implementations)
        return prepare_suites_plan(acxt, context_obj)
    end
}

return default_planner
