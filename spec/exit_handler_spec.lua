_G["__tests"] = {}

local package_name = "luabehave.exit_handler"

describe("Tests for #exit_handler", function()
    local assert_snapshot
    -- luacheck: globals os
    local os_exit = os.exit
    local spy_funcs = {
        os_exit = spy.new(function() end),
    }
    before_each(function()
        assert_snapshot = assert:snapshot()
        os.exit = spy_funcs.os_exit
    end)

    after_each(function()
        assert_snapshot:revert()
        package.loaded[package_name] = nil
        os.exit = os_exit
    end)

    it("exit with error code 1 if has failed steps", function()
        local exit_func = require(package_name)
        local acxt = {
            runner_results = {
                has_failed_steps = true,
            },
        }
        exit_func(acxt)
        assert.spy(spy_funcs.os_exit).was_called_with(1)
    end)
    it("exit with error code 2 if has unimplemented steps", function()
        local exit_func = require(package_name)
        local acxt = {
            args = {
                ["ignore-unimplemented"] = false,
            },
            runner_results = {
                has_unimplemented_steps = true,
            },
        }
        exit_func(acxt)
        assert.spy(spy_funcs.os_exit).was_called_with(2)
    end)
    it("exit with error code 0 if has no failed or unimplemented steps", function()
        local exit_func = require(package_name)
        local acxt = {
            runner_results = {
                has_failed_steps = false,
                has_unimplemented_steps = false,
            },
        }
        exit_func(acxt)
        assert.spy(spy_funcs.os_exit).was_called_with(0)
    end)
end)
