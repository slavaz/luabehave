_G["__tests"] = {}

local package_name = "luabehave.reporter.default.show"

describe("Tests for #reporter.default.show", function()
    local assert_snapshot

    local spy_funcs = {}

    local mocks = {
    }


    before_each(function()
        spy_funcs = {
            show_suite_func = spy.new(function() return false end),
            show_story_func = spy.new(function() return false end),
            show_scenario_func = spy.new(function() return false end),
            show_step_func = spy.new(function() return false end),
        }
        package.loaded["luabehave.reporter.default.show_suite"] = spy_funcs.show_suite_func
        package.loaded["luabehave.reporter.default.show_story"] = spy_funcs.show_story_func
        package.loaded["luabehave.reporter.default.show_scenario"] = spy_funcs.show_scenario_func
        package.loaded["luabehave.reporter.default.show_step"] = spy_funcs.show_step_func
        package.loaded["pl.pretty"] = mocks.plpretty
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded["luabehave.reporter.default.show_suite"] = nil
        package.loaded["luabehave.reporter.default.show_story"] = nil
        package.loaded["luabehave.reporter.default.show_scenario"] = nil
        package.loaded["luabehave.reporter.default.show_step"] = nil
        package.loaded[package_name] = nil
    end)

    it("should return false and call all functions", function()
        local show_func = require(package_name)
        local acxt = {
            keywords = {
                get = function() return {} end
            }
        }
        local result = show_func(acxt, {})
        assert.is_false(result)
        assert.spy(spy_funcs.show_suite_func).was_called(1)
        assert.spy(spy_funcs.show_story_func).was_called(1)
        assert.spy(spy_funcs.show_scenario_func).was_called(1)
        assert.spy(spy_funcs.show_step_func).was_called(1)
    end)
    it("should return true and call only show_suite_func", function()
        spy_funcs.show_suite_func = spy.new(function() return true end)
        package.loaded["luabehave.reporter.default.show_suite"] = spy_funcs.show_suite_func
        local show_func = require(package_name)
        local acxt = {
            keywords = {
                get = function() return {} end
            }
        }
        local result = show_func(acxt, {})
        assert.is_true(result)
        assert.spy(spy_funcs.show_suite_func).was_called(1)
        assert.spy(spy_funcs.show_story_func).was_called(0)
        assert.spy(spy_funcs.show_scenario_func).was_called(0)
        assert.spy(spy_funcs.show_step_func).was_called(0)
    end)
    it("should return true and call  show_suite_func and show_story_func", function()
        spy_funcs.show_story_func = spy.new(function() return true end)
        package.loaded["luabehave.reporter.default.show_story"] = spy_funcs.show_story_func
        local show_func = require(package_name)
        local acxt = {
            keywords = {
                get = function() return {} end
            }
        }
        local result = show_func(acxt, {})
        assert.is_true(result)
        assert.spy(spy_funcs.show_suite_func).was_called(1)
        assert.spy(spy_funcs.show_story_func).was_called(1)
        assert.spy(spy_funcs.show_scenario_func).was_called(0)
        assert.spy(spy_funcs.show_step_func).was_called(0)
    end)
    it("should return true and call  show_suite_func, show_story_func and show_scenario_func", function()
        spy_funcs.show_scenario_func = spy.new(function() return true end)
        package.loaded["luabehave.reporter.default.show_scenario"] = spy_funcs.show_scenario_func
        local show_func = require(package_name)
        local acxt = {
            keywords = {
                get = function() return {} end
            }
        }
        local result = show_func(acxt, {})
        assert.is_true(result)
        assert.spy(spy_funcs.show_suite_func).was_called(1)
        assert.spy(spy_funcs.show_story_func).was_called(1)
        assert.spy(spy_funcs.show_scenario_func).was_called(1)
        assert.spy(spy_funcs.show_step_func).was_called(0)
    end)
    it("should return true and call  show_suite_func, show_story_func, show_scenario_func and show_step_func", function()
        spy_funcs.show_step_func = spy.new(function() return true end)
        package.loaded["luabehave.reporter.default.show_step"] = spy_funcs.show_step_func
        local show_func = require(package_name)
        local acxt = {
            keywords = {
                get = function() return {} end
            }
        }
        local result = show_func(acxt, {})
        assert.is_true(result)
        assert.spy(spy_funcs.show_suite_func).was_called(1)
        assert.spy(spy_funcs.show_story_func).was_called(1)
        assert.spy(spy_funcs.show_scenario_func).was_called(1)
        assert.spy(spy_funcs.show_step_func).was_called(1)
    end)
end)
