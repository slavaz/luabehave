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
        return dofile(config_file_name)
    end
    return {}
end
