local suite = {}

local utils = require('luabehave.utils')
local make_stories_plan = require('luabehave.planner.default.story')
local make_call = require("luabehave.planner.default.make_call")
local get_suites = require("luabehave.planner.default.suite_list")

local function add_before_suite_step(acxt, context)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function()
        acxt.output.info(("Running test suite: %s"):format(context_snapshot.suite_name))
        if context.step_implementations.before_suite then
            return make_call(acxt,
                {
                    context_snapshot = context_snapshot,
                    name = "__before_suite",
                    func = context.step_implementations.before_suite.func,
                    args = {}
                })
        end
    end)
end

local function add_after_suite_step(acxt, context)
    local context_snapshot = context:snapshot()
    utils.add_to_table(context.executable_steps, function()
        if context.step_implementations.after_suite then
            return make_call(acxt,
                {
                    context_snapshot = context_snapshot,
                    name = "__after_suite",
                    func = context.step_implementations.after_suite.func,
                    args = {}
                })
        end
    end)
end

function suite.make_plan(acxt, context)
    local suites = get_suites(acxt, context)
    if #suites == 0 then
        return false, "No suites to run"
    end
    context.suites = suites
    for _, suite_name in ipairs(suites) do
        context:init_suite(suite_name)
        add_before_suite_step(acxt, context)
        make_stories_plan(acxt, context)
        add_after_suite_step(acxt, context)
    end
    return true, context.executable_steps
end

return suite
