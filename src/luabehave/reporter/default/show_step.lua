local plpretty = require("pl.pretty")

local private = {}
if _G["__tests"] then
    _G["__tests"]["reporter_show_step_private"] = private
end

function private.get_output_func(acxt, step_context)
    if step_context.context_snapshot.suite.story.unimplemented
        or step_context.context_snapshot.suite.story.scenario.unimplemented
    then
        return step_context.step.func == nil
            and acxt.output.error
            or acxt.output.warning
    end
    return acxt.output.debug
end

function private.get_keyword(step_context)
    return step_context.step.func == nil
        and ("%s [unimplemented]"):format(step_context.keyword)
        or step_context.keyword
end

function private.get_msg(step_context)
    return step_context.step.name
end

function private.get_format(step_context)
    if step_context.context_snapshot.suite.story.unimplemented then
        return "Skipping %s %s"
    end
    return "Running %s %s"
end

return function(acxt, step_context, _)
    local output_func = private.get_output_func(acxt, step_context)
    local keyword = private.get_keyword(step_context)
    local msg = private.get_msg(step_context)
    local format_msg = private.get_format(step_context)

    output_func(format_msg:format(keyword, msg))

    acxt.output.trace(("args: %s"):format(
        plpretty.write(step_context.step.args)
    ))
    return true
end
