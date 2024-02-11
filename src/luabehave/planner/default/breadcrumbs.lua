local utils = require('luabehave.utils')

return function(acxt, context_snapshot, step_name)
    local breadcrumbs = {}
    local keywords = acxt.keywords.get(acxt)

    if context_snapshot.suite_name then
        utils.add_to_table(breadcrumbs, ("%s %s"):format(keywords.suite, context_snapshot.suite_name))
    end

    if context_snapshot.story_name then
        utils.add_to_table(breadcrumbs,
            ("%s %s (%s)"):format(keywords.story, context_snapshot.story_name, context_snapshot.story_path))
    end

    if context_snapshot.scenario_name then
        utils.add_to_table(breadcrumbs, ("%s %s"):format(keywords.scenario, context_snapshot.scenario_name))
    end
    if context_snapshot.step_type then
        utils.add_to_table(breadcrumbs, ("%s %s"):format(context_snapshot.step_type, step_name))
    end
    return breadcrumbs
end
