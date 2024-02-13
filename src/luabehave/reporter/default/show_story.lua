local private = {}
if _G["__tests"] then
    _G["__tests"]["reporter_show_story_private"] = private
end

function private.get_keyword(step_context)
    return step_context.keyword
end

function private.get_msg(step_context)
    return step_context.context_snapshot.suite.story.name
end

function private.get_output_func(acxt, step_context)
    return step_context.context_snapshot.suite.story.unimplemented
        and acxt.output.warning
        or acxt.output.info
end

function private.get_format(step_context)
    if step_context.context_snapshot.suite.story.unimplemented then
        return "Skipping [unimplemented] %s %s"
    end
    return "Running %s %s"
end

function private.show_before(acxt, step_context, keywords)
    if step_context.keyword ~= keywords.story or step_context.step.name ~= "__before_story" then
        return false
    end
    local output_func = private.get_output_func(acxt, step_context)
    local keyword = private.get_keyword(step_context)
    local msg = private.get_msg(step_context)
    local format_msg = private.get_format(step_context)

    output_func(format_msg:format(keyword, msg))

    return true
end

function private.show_after(acxt, step_context, keywords)
    if step_context.keyword ~= keywords.story or step_context.step.name ~= "__after_story" then
        return false
    end

    acxt.output.debug(("Finishing %s %s"):format(step_context.keyword, step_context.context_snapshot.suite.story
        .name))
    return true
end

return function(acxt, step_context, keywords)
    if private.show_before(acxt, step_context, keywords) then
        return true
    end
    return private.show_after(acxt, step_context, keywords)
end
