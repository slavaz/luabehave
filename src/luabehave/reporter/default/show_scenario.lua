local plpretty = require("pl.pretty")

local private = {}
if _G["__tests"] then
    _G["__tests"]["reporter_show_scenario_private"] = private
end

function private.get_output_func(acxt, step_context)
    if step_context.context_snapshot.suite.story.unimplemented then
        return acxt.output.warning
    end
    return step_context.context_snapshot.suite.story.scenario.unimplemented
        and acxt.output.warning
        or acxt.output.info
end

function private.get_keyword(step_context)
    return step_context.context_snapshot.suite.story.scenario.examples.present
        and ("[#%d] %s"):format(
            step_context.context_snapshot.suite.story.scenario.examples.row_number, step_context.keyword)
        or step_context.keyword
end

function private.get_msg(step_context)
    return step_context.context_snapshot.suite.story.scenario.name
end

function private.get_format(step_context)
    if step_context.context_snapshot.suite.story.unimplemented then
        return "Skipping %s %s"
    end
    if step_context.context_snapshot.suite.story.scenario.unimplemented then
        return "Skipping [unimplemented] %s %s"
    end
    return "Running %s %s"
end

function private.show_before(acxt, step_context, keywords)
    if step_context.keyword ~= keywords.scenario or step_context.step.name ~= "__before_scenario" then
        return false
    end
    local output_func = private.get_output_func(acxt, step_context)
    local keyword = private.get_keyword(step_context)
    local msg = private.get_msg(step_context)
    local format_msg = private.get_format(step_context)

    output_func(format_msg:format(keyword, msg))

    acxt.output.trace(("args: %s"):format(
        plpretty.write(step_context.context_snapshot.suite.story.scenario.examples.args)
    ))
    return true
end

function private.show_after(acxt, step_context, keywords)
    if step_context.keyword == keywords.scenario and step_context.step.name == "__after_scenario" then
        acxt.output.debug(("Finishing %s %s"):format(step_context.keyword,
            step_context.context_snapshot.suite.story.scenario.name))
        return true
    end
    return false
end

return function(acxt, step_context, keywords)
    if private.show_before(acxt, step_context, keywords) then
        return true
    end

    return private.show_after(acxt, step_context, keywords)
end
