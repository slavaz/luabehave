local execute_func = require("luabehave.runner.default.execute")

local default_planner = {
    name = function() return 'default' end,

    run = execute_func,
}

return default_planner
