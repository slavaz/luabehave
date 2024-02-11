local function run(_, execution_plan)
    for _, step in ipairs(execution_plan) do
        step()
    end
    return true
end

local default_planner = {
    name = function() return 'default' end,
    help = require('luabehave.runner.default.help'),

    run = run,
}

return default_planner
