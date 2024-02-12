local environment = require("luabehave.environment")
local get_breadcrumbs = require("luabehave.planner.default.breadcrumbs")
local output_levels = require("luabehave.output.levels")

return function(acxt, step_data)
    environment.set_for_func(step_data.func, step_data.context_snapshot.current_environment)
    local success, result = pcall(step_data.func, step_data.args)

    local breadcrumbs = get_breadcrumbs(acxt, step_data.context_snapshot, step_data.name)
    acxt.reporter.collect(acxt, success and output_levels.INFO or output_levels.ERROR, {
        success = success,
        error_description = result,
        breadcrumbs = breadcrumbs,
    })
    return success, result
end
