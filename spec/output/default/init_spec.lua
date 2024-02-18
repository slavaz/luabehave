describe("Tests for #output.default.init", function()
    local assert_snapshot
    local orig_print = print
    local spy_print = spy.new(function() end)

    before_each(function()
        assert_snapshot = assert:snapshot()
        _G.print = spy_print
    end)
    after_each(function()
        assert_snapshot:revert()
        spy_print:clear()
        _G.print = orig_print
        package.loaded["luabehave.output.default.init"] = nil
    end)

    it("should use global 'print()' function for raw_print() call", function()
        local default_output = require("luabehave.output.default.init")
        default_output.raw_print("test")
        assert.spy(spy_print).was_called_with("test")
    end)
    it("should set logging level from application arguments", function()
        local default_output = require("luabehave.output.default.init")
        local parametrized = {
            [1] = "trace",
            [2] = "debug",
            [3] = "info",
            [4] = "warning",
            [5] = "error"
        }
        for log_level_number, log_level_name in ipairs(parametrized) do
            local acxt = {
                args = {
                    log_level = log_level_name
                }
            }
            default_output.init(acxt)
            assert.is_equal(log_level_number, default_output.level)
        end
    end)
    it("should set logging level to INFO by default", function()
        local default_output = require("luabehave.output.default.init")
        local acxt = {
            args = {}
        }
        default_output.init(acxt)
        assert.is_equal(3, default_output.level)
    end)
    it("should call raw_print() regards to passed log level", function()
        local default_output = require("luabehave.output.default.init")
        default_output.raw_print = spy.new(function() end)
        local levels = {
            [1] = 'TRACE',
            [2] = 'DEBUG',
            [3] = 'INFO',
            [4] = 'WARNING',
            [5] = 'ERROR',
        }
        local parametrized = {
            { level = 1, input_level = 1, msg = "should be shown",    is_shown = true },
            { level = 1, input_level = 2, msg = "should be shown",    is_shown = true },
            { level = 1, input_level = 3, msg = "should be shown",    is_shown = true },
            { level = 1, input_level = 4, msg = "should be shown",    is_shown = true },
            { level = 1, input_level = 5, msg = "should be shown",    is_shown = true },
            { level = 2, input_level = 1, msg = "shouldn't be shown", is_shown = false },
            { level = 2, input_level = 2, msg = "should be shown",    is_shown = true },
            { level = 2, input_level = 3, msg = "should be shown",    is_shown = true },
            { level = 2, input_level = 4, msg = "should be shown",    is_shown = true },
            { level = 2, input_level = 5, msg = "should be shown",    is_shown = true },
            { level = 3, input_level = 1, msg = "shouldn't be shown", is_shown = false },
            { level = 3, input_level = 2, msg = "shouldn't be shown", is_shown = false },
            { level = 3, input_level = 3, msg = "should be shown",    is_shown = true },
            { level = 3, input_level = 4, msg = "should be shown",    is_shown = true },
            { level = 3, input_level = 5, msg = "should be shown",    is_shown = true },
            { level = 4, input_level = 1, msg = "shouldn't be shown", is_shown = false },
            { level = 4, input_level = 2, msg = "shouldn't be shown", is_shown = false },
            { level = 4, input_level = 3, msg = "shouldn't be shown", is_shown = false },
            { level = 4, input_level = 4, msg = "should be shown",    is_shown = true },
            { level = 4, input_level = 5, msg = "should be shown",    is_shown = true },
            { level = 5, input_level = 1, msg = "shouldn't be shown", is_shown = false },
            { level = 5, input_level = 2, msg = "shouldn't be shown", is_shown = false },
            { level = 5, input_level = 3, msg = "shouldn't be shown", is_shown = false },
            { level = 5, input_level = 4, msg = "shouldn't be shown", is_shown = false },
            { level = 5, input_level = 5, msg = "should be shown",    is_shown = true },
        }
        for _, param in ipairs(parametrized) do
            default_output.level = param.level
            default_output.print(param.input_level, param.msg)
            if param.is_shown then
                assert.spy(default_output.raw_print).was_called_with(("[%s]: %s"):format(levels[param.input_level],
                    param.msg))
            else
                assert.spy(default_output.raw_print).was_not_called()
            end
            default_output.raw_print:clear()
        end
    end)
    it("Should show trace message", function()
        local default_output = require("luabehave.output.default.init")
        default_output.print = spy_print

        default_output.trace("test")
        assert.spy(spy_print).was_called_with(1, "test")
    end)
    it("Should show debug message", function()
        local default_output = require("luabehave.output.default.init")
        default_output.print = spy_print

        default_output.debug("test")
        assert.spy(spy_print).was_called_with(2, "test")
    end)
    it("Should show info message", function()
        local default_output = require("luabehave.output.default.init")
        default_output.print = spy_print

        default_output.info("test")
        assert.spy(spy_print).was_called_with(3, "test")
    end)
    it("Should show warning message", function()
        local default_output = require("luabehave.output.default.init")
        default_output.print = spy_print

        default_output.warning("test")
        assert.spy(spy_print).was_called_with(4, "test")
    end)
    it("Should show error message", function()
        local default_output = require("luabehave.output.default.init")
        default_output.print = spy_print

        default_output.error("test")
        assert.spy(spy_print).was_called_with(5, "test")
    end)
end)
