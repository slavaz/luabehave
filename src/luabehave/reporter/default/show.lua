local show_suite_func = require('luabehave.reporter.default.show_suite')
local show_story_func = require('luabehave.reporter.default.show_story')
local show_scenario_func = require('luabehave.reporter.default.show_scenario')
local show_step_func = require('luabehave.reporter.default.show_step')

return function(acxt, step_context)
    local keywords = acxt.keywords.get()
    if show_suite_func(acxt, step_context, keywords) then return true end

    if show_story_func(acxt, step_context, keywords) then return true end
    if show_scenario_func(acxt, step_context, keywords) then return true end
    return show_step_func(acxt, step_context, keywords)
end
