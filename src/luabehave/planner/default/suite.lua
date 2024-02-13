local utils = require('luabehave.utils')
local prepare_stories_plan = require('luabehave.planner.default.story')
local get_suites = require("luabehave.planner.default.suite_list")

local private = {}
if _G["__tests"] then
    _G["__tests"]["planner_suite_private"] = private
end

function private.prepare_before_suite_handler(acxt, context)
    local func = context.step_implementations.before_suite
        and context.step_implementations.before_suite.func or nil
    utils.add_to_table(context.executable_steps, {
        keyword = acxt.keywords.get(acxt).suite,
        context_snapshot = context:snapshot(),
        step = {
            name = "__before_suite",
            func = func,
            args = {},
        },
    })
end

function private.prepare_after_suite_handler(acxt, context)
    local func = context.step_implementations.after_suite
        and context.step_implementations.after_suite.func or nil
    utils.add_to_table(context.executable_steps, {
        keyword = acxt.keywords.get(acxt).suite,
        context_snapshot = context:snapshot(),
        step = {
            name = "__after_suite",
            func = func,
            args = {},
        },
    })
end

return function (acxt, context)
    local suites = get_suites(acxt, context)
    if #suites == 0 then
        return false, "No suites to run"
    end
    context.suites = suites
    for _, suite_name in ipairs(suites) do
        context:init_suite(suite_name)
        private.prepare_before_suite_handler(acxt, context)
        prepare_stories_plan(acxt, context)
        private.prepare_after_suite_handler(acxt, context)
    end
    return true, context.executable_steps
end
