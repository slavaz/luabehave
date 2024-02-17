local reporter = require("luabehave.reporter.default")
local environment = require("luabehave.environment")

local private = {}

if _G["__tests"] then
    _G["__tests"]["runner_default_execute"] = private
end

function private.is_step_unimplemented(step_context)
    return step_context.context_snapshot.suite.story.unimplemented
        or step_context.context_snapshot.suite.story.scenario.unimplemented
end

function private.execute_step(_, step_context)
    step_context.success = true
    if not step_context.step.func then return true end

    local ret_val, result
    local orig_G = _G
    do
        _G = step_context.context_snapshot.current_environment
        environment.set_for_func(step_context.step.func, step_context.context_snapshot.current_environment)
        ret_val, result = pcall(step_context.step.func, step_context.step.args)
    end
    _G = orig_G

    step_context.success = ret_val
    if not ret_val then
        return false, result
    end
    return true
end

return function(acxt, execution_plan)
    acxt.runner_results = {
        has_unimplemented_steps = false,
        has_failed_steps = false,
    }
    for _, step_context in ipairs(execution_plan) do
        local step_unimplemented = private.is_step_unimplemented(step_context)
        if step_unimplemented then
            acxt.runner_results.has_unimplemented_steps = true
        end
        reporter.show(acxt, step_context)
        if not step_unimplemented then
            local ret_val, result = private.execute_step(acxt, step_context)
            if not ret_val then
                acxt.output.error(result)
                acxt.runner_results.has_failed_steps = true
            end
        end
        reporter.collect(acxt, step_context)
    end
end
