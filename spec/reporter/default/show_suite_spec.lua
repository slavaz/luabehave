_G["__tests"] = {}

local function get_private()
    return _G["__tests"]["reporter_show_suite_private"]
end
local package_name = "luabehave.reporter.default.show_suite"

describe("Tests for #reporter.default.show_suite", function()
    local assert_snapshot
    local spy_funcs = {
        output_debug = spy.new(function() end),
        output_info = spy.new(function() end),
        output_trace = spy.new(function() end),
        output_warning = spy.new(function() end),
        output_error = spy.new(function() end),
    }
    local mock_tables = {
        output = {
            debug = spy_funcs.output_debug,
            warning = spy_funcs.output_warning,
            error = spy_funcs.output_error,
            info = spy_funcs.output_info,
            trace = spy_funcs.output_trace,
        },

        plpretty = {
            write = function() end,
        },
    }
    before_each(function()
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
    end)
    it("should show before suite information", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Suite",
            step = {
                name = "__before_suite",
            },
            context_snapshot = {
                suite = {
                    name = "A Suite",
                },
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local keywords = {
            suite = "Suite",
        }
        local result = private.show_before(acxt, step_context, keywords)
        assert.is_true(result)
        assert.spy(spy_funcs.output_info).was_called_with("Running Suite A Suite")
        assert.spy(spy_funcs.output_warning).was_not_called()
        assert.spy(spy_funcs.output_debug).was_not_called()
        assert.spy(spy_funcs.output_trace).was_not_called()
        assert.spy(spy_funcs.output_error).was_not_called()
    end)
    it("should show after suite information", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Suite",
            step = {
                name = "__after_suite",
            },
            context_snapshot = {
                suite = {
                    name = "A Suite",
                },
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local keywords = {
            suite = "Suite",
        }
        local result = private.show_after(acxt, step_context, keywords)
        assert.is_true(result)
        assert.spy(spy_funcs.output_debug).was_called_with("Finishing Suite A Suite")
        assert.spy(spy_funcs.output_info).was_not_called()
        assert.spy(spy_funcs.output_warning).was_not_called()
        assert.spy(spy_funcs.output_trace).was_not_called()
        assert.spy(spy_funcs.output_error).was_not_called()
    end)
    it("should not show before suite information", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Scenario",
            step = {
                name = "__before_suite",
            },
            context_snapshot = {
                suite = {
                    name = "A Suite",
                },
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local keywords = {
            suite = "Suite",
        }
        local result = private.show_before(acxt, step_context, keywords)
        assert.is_false(result)
        assert.spy(spy_funcs.output_info).was_not_called()
        assert.spy(spy_funcs.output_warning).was_not_called()
        assert.spy(spy_funcs.output_debug).was_not_called()
        assert.spy(spy_funcs.output_trace).was_not_called()
        assert.spy(spy_funcs.output_error).was_not_called()
    end)
    it("should not show after suite information", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Scenario",
            step = {
                name = "__after_suite",
            },
            context_snapshot = {
                suite = {
                    name = "A Suite",
                },
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local keywords = {
            suite = "Suite",
        }
        local result = private.show_after(acxt, step_context, keywords)
        assert.is_false(result)
        assert.spy(spy_funcs.output_debug).was_not_called()
        assert.spy(spy_funcs.output_info).was_not_called()
        assert.spy(spy_funcs.output_warning).was_not_called()
        assert.spy(spy_funcs.output_trace).was_not_called()
        assert.spy(spy_funcs.output_error).was_not_called()
    end)
    it("should run show_before function", function()
        local show_suite = require(package_name)
        local private = get_private()
        private.show_before = spy.new(function() return true end)
        private.show_after = spy.new(function() return false end)
        local result = show_suite({}, {}, {})
        assert.is_true(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_not_called()
    end)
    it("should run show_after function", function()
        local show_suite = require(package_name)
        local private = get_private()
        private.show_before = spy.new(function() return false end)
        private.show_after = spy.new(function() return true end)
        local result = show_suite({}, {}, {})
        assert.is_true(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_called()
    end)
    it("should return false", function()
        local show_suite = require(package_name)
        local private = get_private()
        private.show_before = spy.new(function() return false end)
        private.show_after = spy.new(function() return false end)
        local result = show_suite({}, {}, {})
        assert.is_false(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_called()
    end)
end)
