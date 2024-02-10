local function default_assignment(func)
    return {
        func = func,
    }
end

local function do_error(message)
    error(message)
end

local function check_func(func)
    assert(func, "Expected function, got nil")
    assert(type(func) == "function", "Expected function, got: " .. type(func))
end

local function check_step_name(step_name)
    assert(step_name, "Step name: expected string, got nil")
    assert(type(step_name) == "string", "Step name: expected string, got: " .. type(step_name))
end

local function init_environment(env, steps)
    local function_map = {
        ["Given"] = function(step_name, func)
            check_step_name(step_name)
            if steps["given"][step_name] then
                do_error("Step with name " .. step_name .. " already exists")
            end
            check_func(func)
            steps["given"][step_name] = default_assignment(func)
        end,
        ["When"] = function(step_name, func)
            check_step_name(step_name)
            if steps["when"][step_name] then
                do_error("Step with name " .. step_name .. " already exists")
            end
            check_func(func)
            steps["when"][step_name] = default_assignment(func)
        end,
        ["Then"] = function(step_name, func)
            check_step_name(step_name)
            if steps["then"][step_name] then
                do_error("Step with name " .. step_name .. " already exists")
            end
            check_func(func)
            steps["then"][step_name] = default_assignment(func)
        end,
        ["BeforeScenario"] = function(func)
            if steps["before_scenario"] then
                do_error("BeforeScenario already exists")
            end
            check_func(func)
            steps["before_scenario"] = default_assignment(func)
        end,
        ["AfterScenario"] = function(func)
            if steps["after_scenario"] then
                do_error("AfterScenario already exists")
            end
            check_func(func)
            steps["after_scenario"] = default_assignment(func)
        end,
        ["BeforeStory"] = function(func)
            if steps["before_story"] then
                do_error("BeforeStory already exists")
            end
            check_func(func)
            steps["before_story"] = default_assignment(func)
        end,
        ["AfterStory"] = function(func)
            if steps["after_story"] then
                do_error("AfterStory already exists")
            end
            check_func(func)
            steps["after_story"] = default_assignment(func)
        end,
        ["BeforeSuite"] = function(func)
            if steps["before_suite"] then
                do_error("BeforeSuite already exists")
            end
            steps["before_suite"] = default_assignment(func)
        end,
        ["AfterSuite"] = function(func)
            if steps["after_suite"] then
                do_error("AfterSuite already exists")
            end
            check_func(func)
            steps["after_suite"] = default_assignment(func)
        end,
    }

    for key, value in pairs(function_map) do
        env[key] = value
    end
end

local function call_steps(file_name, env)
    local ret_val, result = pcall(assert(loadfile(file_name, 'bt', env)))
    if not ret_val then
        return false, ("An error occured in the file '%s':\n%s"):format(file_name, result)
    end
    return true
end

return function(_, file_list)
    local steps = {
        ["given"] = {},
        ["when"] = {},
        ["then"] = {},
        ["before_scenario"] = nil,
        ["after_scenario"] = nil,
        ["before_story"] = nil,
        ["after_story"] = nil,
        ["before_suite"] = nil,
        ["after_suite"] = nil,
    }

    for _, file_name in ipairs(file_list) do
        local env = setmetatable({}, { __index = _G })
        init_environment(env, steps)

        local ret_val, result = call_steps(file_name, env)
        if not ret_val then
            return false, result
        end
    end
    return true, steps
end
