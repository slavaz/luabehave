local utils = require('luabehave.utils')

return function(acxt, context, step_name)
    local breadcrumbs = {}
    local keywords = acxt.keywords.get(acxt)

    if context.suite.name then
        utils.add_to_table(breadcrumbs, ("%s %s"):format(keywords.suite, context.suite.name))
    end

    if context.suite.story.name then
        utils.add_to_table(breadcrumbs,
            ("%s %s (%s)"):format(keywords.story, context.suite.story.name, context.suite.story.path))
    end

    if context.suite.story.scenario.name then
        utils.add_to_table(breadcrumbs, ("%s %s"):format(keywords.scenario, context.suite.story.scenario.name))
    end
    if context.step_type then
        utils.add_to_table(breadcrumbs, ("%s %s"):format(context.step_type, step_name))
    end
    return breadcrumbs
end
