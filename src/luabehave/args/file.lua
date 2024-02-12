local environment = require("luabehave.environment")

local function file_exists(filename)
    local file = io.open(filename, "r")
    if not file then
        return false
    end
    io.close(file)
    return true
end

return function(config_file_name)
    if file_exists(config_file_name) then
        local executable_chunk = assert(loadfile(config_file_name))
        environment.set_for_func(executable_chunk, {})
        local _, result = assert(pcall(executable_chunk))
        return result
    end
    return {}
end
