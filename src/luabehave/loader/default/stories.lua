return function(acxt, file_list)
    local stories = {}
    for _, file_name in ipairs(file_list) do
        local file = io.open(file_name, "r")
        if not file then
            return false, ("Could not open file: %s"):format(file_name)
        end
        local ret_value, result = acxt.parser.parse(acxt, file)
        file:close()
        if not ret_value then
            return false, ("Could not parse file: %s\n%s"):format(file_name, result)
        end
        stories[file_name] = result
    end
    return true, stories
end
