_G["__tests"] = {}

local function get_private()
    return _G["__tests"]["reporter_show_step_private"]
end
local package_name = "luabehave.reporter.default.show_step"

describe("Tests for #reporter.default.show_step", function()
    local assert_snapshot
    local spy_funcs = {
    }
    local mock_tables = {
        output = {
            debug = function() end,
            warning = function() end,
            error = function() end,
            info = function() end,
            trace = function() end,
        },

        plpretty = {
            write = function() end,
        },
    }
    before_each(function()
        package.loaded["luabehave.output.default"] = mock_tables.reporter
        package.loaded["pl.pretty"] = mock_tables.plpretty
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
    end)
    it("should return 'debug' output function if step is implemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = false,
                        },
                    },
                },
            },
            step = {
                func = function() end,
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local result = private.get_output_func(acxt, step_context)
        assert.is_equal(mock_tables.output.debug, result)
    end)
    it("should return 'warning' output function if step in scenario is unimplemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = true,
                        },
                    },
                },
            },
            step = {
                func = nil,
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local result = private.get_output_func(acxt, step_context)
        assert.is_equal(mock_tables.output.error, result)
    end)
    it("should return 'warning' output function if step in story is unimplemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = true,
                        scenario = {
                            unimplemented = false,
                        },
                    },
                },
            },
            step = {
                func = nil,
            },
        }
        local acxt = {
            output = mock_tables.output,
        }
        local result = private.get_output_func(acxt, step_context)
        assert.is_equal(mock_tables.output.error, result)
    end)
    it("should return a keyword if step is implemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            step = {
                func = function() end,
            },
            keyword = "Given",
        }
        local result = private.get_keyword(step_context)
        assert.is_equal("Given", result)
    end)
    it("should return a keyword with [unimplemented] if step is unimplemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            step = {
                func = nil,
            },
            keyword = "Given",
        }
        local result = private.get_keyword(step_context)
        assert.is_equal("Given [unimplemented]", result)
    end)
    it("should return a message", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            step = {
                name = "step name",
            },
        }
        local result = private.get_msg(step_context)
        assert.is_equal("step name", result)
    end)
    it("should return a format for implemented step", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = false,
                        },
                    },
                },
            },
        }
        local result = private.get_format(step_context)
        assert.is_equal("Running %s %s", result)
    end)
    it("should return a format for a step in unimplemented scenario or a story", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = true,
                        },
                    },
                },
            },
        }
        local result = private.get_format(step_context)
        assert.is_equal("Skipping %s %s", result)
    end)
    it("should show steo info", function()
        local show_step_info = require(package_name)
        local private = get_private()
        private.get_output_func = spy.new(function() return mock_tables.output.debug end)
        private.get_keyword = spy.new(function() return "Given" end)
        private.get_msg = spy.new(function() return "step name" end)
        private.get_format = spy.new(function() return "Running %s %s" end)
        mock_tables.output.debug = spy.new(function() end)
        mock_tables.output.trace = spy.new(function() end)
        mock_tables.plpretty.write = spy.new(function() return "{}" end)
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = false,
                        },
                    },
                },
            },
            step = {
                func = function() end,
                name = "step name",
                args = {},
            },
            keyword = "Given",
        }
        local acxt = {
            output = mock_tables.output,
        }
        show_step_info(acxt, step_context, nil)
        assert.spy(private.get_output_func).was_called_with(acxt, step_context)
        assert.spy(private.get_keyword).was_called_with(step_context)
        assert.spy(private.get_msg).was_called_with(step_context)
        assert.spy(private.get_format).was_called_with(step_context)
        assert.spy(mock_tables.output.debug).was_called_with("Running Given step name")
        assert.spy(mock_tables.output.trace).was_called_with("args: {}")
        assert.spy(mock_tables.plpretty.write).was_called_with(step_context.step.args)
    end)
end)
