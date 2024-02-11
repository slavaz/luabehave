local defaults = {
    ["planner.default.suites"] = "",
    ["planner.default.suite.name"] = "default",
}

return function(args)
    args = args or {}
    if args["suites"] then
        args["planner.default.suites"] = args["suites"]
    end
    for k, v in pairs(defaults) do
        if args[k] == nil then
            args[k] =  v
        end
    end
    return args
end
