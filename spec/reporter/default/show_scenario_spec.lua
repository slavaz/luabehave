_G["__tests"] = {}

local function get_private()
    return _G["__tests"]["reporter_show_scenario_private"]
end
local package_name = "luabehave.reporter.default.show_scenario"

describe("Tests for #reporter.default.show_scenario", function()
    local assert_snapshot

    local spy_funcs = {
    }
    local mocks = {
        output = mock({
            warning = function() end,
            info = function() end,
            trace = function() end,
            debug = function() end,
        },true),
        plpretty = mock({
            write = function() end,
        },true),
    }


    before_each(function()
        package.loaded["luabehave.output.default"] = mock.reporter
        package.loaded["pl.pretty"] = mocks.plpretty
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
    end)

    it("should return 'info' output function", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                warning = function() end,
                info = function() end,
            },
        }
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
        local result = private.get_output_func(acxt, step_context)
        assert.is_equal(acxt.output.info, result)
    end)
    it("should return 'warning' output function if scenario is not implemented", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                warning = function() end,
                info = function() end,
            },
        }
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
        local result = private.get_output_func(acxt, step_context)
        assert.is_equal(acxt.output.warning, result)
    end)
    it("should return 'warning' output function if story is not implemented", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                warning = function() end,
                info = function() end,
            },
        }
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
        }
        local result = private.get_output_func(acxt, step_context)
        assert.is_equal(acxt.output.warning, result)
    end)
    it("should return a keyword from scenario", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        scenario = {
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
            keyword = "Scenario: ",
        }
        local result = private.get_keyword(step_context)
        assert.is_equal("Scenario: ", result)
    end)
    it("should return a keyword from scenario with examples", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        scenario = {
                            examples = {
                                present = true,
                                row_number = 123,
                            },
                        },
                    },
                },
            },
            keyword = "Scenario: ",
        }
        local result = private.get_keyword(step_context)
        assert.is_equal("[#123] Scenario: ", result)
    end)
    it("should return a message from scenario", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        scenario = {
                            name = "scenario",
                        },
                    },
                },
            },
        }
        local result = private.get_msg(step_context)
        assert.is_equal("scenario", result)
    end)
    it("should return a format for message from scenario", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local result = private.get_format(step_context)
        assert.is_equal("Running %s %s", result)
    end)
    it("should return a format for message from scenario if story is not implemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = true,
                        scenario = {
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local result = private.get_format(step_context)
        assert.is_equal("Skipping %s %s", result)
    end)
    it("should return a format for message from scenario if scenario is not implemented", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = true,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local result = private.get_format(step_context)
        assert.is_equal("Skipping [unimplemented] %s %s", result)
    end)
    it("should not show before scenario because it's a handler, but not  a scenario handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                warning = function() end,
                info = function() end,
            },
        }
        local step_context = {
            keyword = "Story: ",
            step = {
                name = "__before_scenario",
            },
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local keywords = {
            scenario = "Scenario: ",
        }
        local result = private.show_before(acxt, step_context, keywords)
        assert.is_false(result)
    end)
    it("should not show before scenario because it isn't a handler, but it's  a scenario", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                warning = function() end,
                info = function() end,
            },
        }
        local step_context = {
            keyword = "Scenario: ",
            step = {
                name = "step",
            },
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local keywords = {
            scenario = "Scenario: ",
        }
        local result = private.show_before(acxt, step_context, keywords)
        assert.is_false(result)
    end)
    it("should show before scenario", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                warning = function() end,
                info = function() end,
            },
            trace = function() end,
        }
        local step_context = {
            keyword = "Scenario: ",
            step = {
                name = "__before_scenario",
            },
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            name = "scenario",
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local keywords = {
            scenario = "Scenario: ",
        }
        spy.on(acxt.output, "info")
        spy.on(acxt.output, "trace")
        local result = private.show_before(acxt, step_context, keywords)
        assert.is_true(result)
        assert.spy(acxt.output.info).was_called_with("Running Scenario:  scenario")
        assert.spy(acxt.output.trace).was_called_with("args: nil")
    end)
    it("should show after scenario message if it'a a scenario handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                debug = function() end,
            },
        }
        local step_context = {
            keyword = "Scenario: ",
            step = {
                name = "__after_scenario",
            },
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            name = "scenario",
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local keywords = {
            scenario = "Scenario: ",
        }
        spy.on(acxt.output, "debug")
        local result = private.show_after(acxt, step_context, keywords)
        assert.is_true(result)
        assert.spy(acxt.output.debug).was_called_with("Finishing Scenario:  scenario")
    end)
    it("should not show after scenario message if it's not a scenario handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                debug = function() end,
            },
        }
        local step_context = {
            keyword = "Story: ",
            step = {
                name = "__after_scenario",
            },
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            name = "scenario",
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local keywords = {
            scenario = "Scenario: ",
        }
        local result = private.show_after(acxt, step_context, keywords)
        assert.is_false(result)
    end)
    it("should show after scenario message if it's a scenario handler, but not a scenario", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = {
                debug = function() end,
            },
        }
        local step_context = {
            keyword = "Story: ",
            step = {
                name = "__after_scenario",
            },
            context_snapshot = {
                suite = {
                    story = {
                        unimplemented = false,
                        scenario = {
                            name = "scenario",
                            unimplemented = false,
                            examples = {
                                present = false,
                            },
                        },
                    },
                },
            },
        }
        local keywords = {
            scenario = "Scenario: ",
        }
        local result = private.show_after(acxt, step_context, keywords)
        assert.is_false(result)
    end)
    it("should run show_before function", function()
        local show_scenario = require(package_name)
        local private = get_private()

        private.show_before = spy(function() return true end)
        private.show_after = spy(function() end)

        local result = show_scenario({}, {}, {})
        assert.is_true(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_not_called()
    end)
    it("should run show_after function", function()
        local show_scenario = require(package_name)
        local private = get_private()

        private.show_before = spy(function() return false end)
        private.show_after = spy(function() return true end)

        local result = show_scenario({}, {}, {})
        assert.is_true(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_called()
    end)
    it("should return false", function()
        local show_scenario = require(package_name)
        local private = get_private()

        private.show_before = spy(function() return false end)
        private.show_after = spy(function() return false end)

        local result = show_scenario({}, {}, {})
        assert.is_false(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_before).was_called()
    end)
end)
