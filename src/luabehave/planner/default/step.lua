local utils = require("luabehave.utils")
local make_call = require("luabehave.planner.default.make_call")

local function make_step(acxt, context, implemented_steps, step)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function()
        if context_snapshot.scenario_unimplemented then
            if implemented_steps[step.name] then
                acxt.output.warning(("[Skipping]: %s"):format(step.name))
            else
                acxt.output.error(("[Unimplemented]: %s"):format(step.name))
                acxt.exit_code = 1
            end
            return
        end
        local largs = step.args
        if context_snapshot.scenario_examples_present then
            largs = utils.merge(step.args, context_snapshot.scenario_examples_args)
        end

        return make_call(acxt,
            {
                context_snapshot = context:snapshot(),
                step.name,
                func = implemented_steps[step.name].func,
                args = largs
            })
    end)
end


return function(acxt, context, implemented_steps, steps)
    for _, step in ipairs(steps) do
        make_step(acxt, context, implemented_steps, step)
    end
end
