local defaults = {
    ["finder.default.step.extention"] = "_steps.lua",
    ["finder.default.step.path"] = "bdd/steps",
    ["finder.default.story.extention"] = ".story",
    ["finder.default.story.path"] = "bdd/stories",
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
