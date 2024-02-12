local ContextClass = require('luabehave.planner.default.context')
local suite = require('luabehave.planner.default.suite')

local function make_plan(acxt, stories, step_implementations)
    local context_obj = ContextClass(stories, step_implementations)
    return suite.make_plan(acxt, context_obj)
end

local default_planner = {
    name = function() return 'default' end,

    make_plan = make_plan,
}

return default_planner
