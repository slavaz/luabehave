local collect = require('luabehave.reporter.default.collect')
local show = require('luabehave.reporter.default.show')

local default_reporter = {

    context = {},

    name = function() return 'default' end,

    init = function(acxt)
        acxt.reporter.context = {
            steps_results = {},
        }
    end,
    collect = collect,
    show = show,
}

return default_reporter
