local environment = {}

local function get_upvalue(fn, search_name)
    local idx = 1
    while true do
        local name, val = debug.getupvalue(fn, idx)
        if not name then break end
        if name == search_name then
            return idx, val
        end
        idx = idx + 1
    end
end

function environment.set_for_func(func, env)
    debug.setupvalue(func, get_upvalue(func, "_ENV"), env)
end

function environment.init(parent_env)
    local env = setmetatable({}, { __index = _G })
    if parent_env then
        env.get_parent_environment = function(_)
            return parent_env
        end
    end
    return env
end

return environment
