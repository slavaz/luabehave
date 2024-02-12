return function(args)
    if not args then
        error("No args provided")
    end
    if type(args) ~= "table" then
        error("Args must be a table")
    end
    for k, v in pairs(args) do
        if type(k) ~= "string" then
            error("All keys in args must be strings")
        end
        if type(v) ~= "string" then
            error("All values in args must be strings")
        end
    end
end
