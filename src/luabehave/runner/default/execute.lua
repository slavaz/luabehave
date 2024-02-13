local reporter = require("luabehave.reporter.default")

local private = {}
if _G["__tests"] then
    _G["__tests"]["runner_default_execute"] = private
end

function private.is_step_unimplemented(step_context)
    return step_context.context_snapshot.suite.story.unimplemented
        or step_context.context_snapshot.suite.story.scenario.unimplemented
end

function private.execute_step(acxt, step_context)
    if private.is_step_unimplemented(step_context) then
        return true
    end
    if not step_context.step.func then return true end

    local ret_val, result
    local orig_G = _G
    do
        _G = step_context.context_snapshot.current_environment
        ret_val, result = pcall(step_context.step.func, step_context.step.args)
        step_context.success = ret_val
        _G = orig_G
    end
    if not ret_val then
        acxt.output.error(result)
        acxt.runner_results.has_failed_steps = true
    end
    return true
end

return function(acxt, execution_plan)
    acxt.runner_results = {
        has_unimplemented_steps = false,
        has_failed_steps = false,
    }
    for _, step_context in ipairs(execution_plan) do
        if private.is_step_unimplemented(step_context) then
            acxt.runner_results.has_unimplemented_steps = true
        end
        reporter.show(acxt, step_context)
        if not private.execute_step(acxt, step_context) then
            acxt.runner_results.has_failed_steps = true
        end
        reporter.collect(acxt, step_context)
    end
end
