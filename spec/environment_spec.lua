describe("Testing environment functions", function()
    local environment = require("luabehave.environment")
    -- luacheck: push ignore _ENV
    local orig_ENV = _ENV
    -- luacheck: pop
    teardown(function()
        -- luacheck: push ignore _ENV
        _ENV = orig_ENV
        -- luacheck: pop
    end)
    it("should set environment for function correctly", function()
        -- luacheck: push ignore _ENV
        local func = function() return _ENV end
        -- luacheck: pop
        local env = { var = "value" }
        environment.set_for_func(func, env)

        orig_ENV.assert.equal(env, func())
    end)

    it("should initialize environment correctly without parent", function()
        local env = environment.init()

        orig_ENV.assert.is_table(env)
        orig_ENV.assert.is_nil(env.get_parent_environment)
    end)

    it("should initialize environment correctly with parent", function()
        local parent_env = { var = "value" }
        local env = environment.init(parent_env)

        orig_ENV.assert.is_table(env)
        orig_ENV.assert.is_function(env.get_parent_environment)
        orig_ENV.assert.equal(parent_env, env:get_parent_environment())
    end)
end)
