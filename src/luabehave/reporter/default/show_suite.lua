local private = {}
if _G["__tests"] then
    _G["__tests"]["reporter_show_suite_private"] = private
end

function private.show_before(acxt, step_context, keywords)
    if step_context.keyword ~= keywords.suite or step_context.step.name ~= "__before_suite" then
        return false
    end
    acxt.output.info(("Running %s %s"):format(step_context.keyword, step_context.context_snapshot.suite.name))

    return true
end

function private.show_after(acxt, step_context, keywords)
    if step_context.keyword ~= keywords.suite or step_context.step.name ~= "__after_suite" then
        return false
    end

    acxt.output.debug(("Finishing %s %s"):format(step_context.keyword, step_context.context_snapshot.suite.name))
    return true
end

return function(acxt, step_context, keywords)
    if private.show_before(acxt, step_context, keywords) then
        return true
    end
    return private.show_after(acxt, step_context, keywords)
end
