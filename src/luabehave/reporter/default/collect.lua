local Context = require("luabehave.reporter.default.context")

return function(acxt, steps_context)
    acxt.reporter_context = acxt.reporter_context or Context()
    acxt.reporter_context:add(steps_context)
end
