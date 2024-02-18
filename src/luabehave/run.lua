local utils = require("luabehave.utils")

return function(application_context)
    application_context.reporter.init(application_context)
    local ret_val, stories, step_definitions, parsed_stories, step_contents, execution_plan
    ret_val, stories = application_context.finder.search_stories(application_context)
    if not ret_val then return false, stories end
    if utils.is_table_empty(stories) then
        return false, "No stories found"
    end

    ret_val, step_definitions = application_context.finder.search_steps(application_context)
    if not ret_val then return false, step_definitions end

    ret_val, parsed_stories = application_context.loader.load_stories(application_context, stories)
    if not ret_val then return false, parsed_stories end
    ret_val, step_contents = application_context.loader.load_steps(application_context, step_definitions)
    if not ret_val then return false, step_contents end

    ret_val, execution_plan = application_context.planner.prepare_plan(
        application_context,
        parsed_stories,
        step_contents
    )
    if not ret_val then return false, execution_plan end

    application_context.runner.run(application_context, execution_plan)

    application_context.reporter.show_summary(application_context)
    return true
end
