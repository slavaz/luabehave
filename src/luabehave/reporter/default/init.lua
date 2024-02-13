local collect = require('luabehave.reporter.default.collect')
local show_func = require('luabehave.reporter.default.show')
local show_summary_func = require('luabehave.reporter.default.show_summary')

local default_reporter = {

    context = {},

    name = function() return 'default' end,

    init = function(acxt)
        acxt.reporter.context = {
            steps_results = {},
        }
    end,
    collect = collect,
    show = show_func,
    show_summary = show_summary_func,
}

return default_reporter
