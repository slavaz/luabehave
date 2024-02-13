local utils = require("luabehave.utils")

return function(planner_context, implemented_steps, story_steps, steps_keyword)
    for _, step in ipairs(story_steps) do
        local context_snapshot = planner_context:snapshot()

        local largs
        if context_snapshot.suite.story.scenario.examples.present then
            largs = utils.merge(step.args,
                context_snapshot.suite.story.scenario.examples.args)
        else
            largs = utils.merge(step.args, {})
        end

        local step_context = {
            keyword = steps_keyword,
            context_snapshot = context_snapshot,
            step = {
                name = step.name,
                func = implemented_steps[step.name] and implemented_steps[step.name].func or nil,
                args = largs,
            },
        }
        utils.add_to_table(planner_context.executable_steps, step_context)
    end
end
