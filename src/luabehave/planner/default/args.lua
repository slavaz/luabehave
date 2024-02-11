local defaults = {
    ["planner.default.suites"] = "",
    ["planner.default.suite.name"] = "default",
}

return function(args)
    args = args or {}
    for k, v in pairs(defaults) do
        if args[k] == nil then
            args[k] =  v
        end
    end
    return args
end
