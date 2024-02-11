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

function environment.set_for_func(func, environment)
    debug.setupvalue(func, get_upvalue (func, "_ENV"), environment)
end

function environment.init(parent_environment)
    local environment = setmetatable({}, { __index = _G })
    if parent_environment then
        environment.get_parent_environment = function(self)
            return parent_environment
        end
    end
    return environment
end

return environment
