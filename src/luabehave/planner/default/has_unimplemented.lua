return function(scenario_steps, step_implementations)
    if not scenario_steps then return false end
    local ret_val = false

    for _, step in ipairs(scenario_steps) do
        if not step_implementations[step.name] then
            ret_val = true
            break
        end
    end
    return ret_val
end
