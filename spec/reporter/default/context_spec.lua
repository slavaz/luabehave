_G["__tests"] = {}
local function get_private()
    return _G["__tests"]["runner_default_execute"]
end
local package_name = "luabehave.reporter.default.context"

describe("Tests for #runner.default.execute", function()
    local ContextClass
    local assert_snapshot

    local spy_funcs = {
        add_suite = spy.new(function() end),
        add_story = spy.new(function() end),
        add_scenario = spy.new(function() end),
    }
    before_each(function()
        assert_snapshot = assert:snapshot()
        ContextClass = require(package_name)
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
    end)

    it("should recognise if is a step", function()
        local context = ContextClass()

        local parametrized = {
            { name = "__before_suite",    result = false },
            { name = "__after_suite",     result = false },
            { name = "__before_story",    result = false },
            { name = "__after_story",     result = false },
            { name = "__before_scenario", result = false },
            { name = "__after_scenario",  result = false },
            { name = "step",              result = true },
            { name = "step 2",            result = true },
        }
        for _, v in ipairs(parametrized) do
            local step_context = {
                step = {
                    name = v.name,
                },
            }
            local result = context:is_step(step_context)
            assert.is_equal(v.result, result)
        end
    end)

    it("should make a breadcrumb", function()
        local context = ContextClass()

        local step_context = {
            context_snapshot = {
                suite = {
                    name = "suite",
                    story = {
                        path = "story",
                        scenario = {
                            number = 1,
                        },
                    },
                },
            },
            step = {
                func = nil,
            },
        }
        local result = context:make_breadcrumb(step_context)
        assert.is_same({
            suite = "suite",
            story = "story",
            scenario = 1,
            is_step = true,
        }, result)
    end)
    it("should add suite", function()
        local context = ContextClass()

        local breadcrumb = {
            suite = "suite_1",
        }
        context:add_suite(breadcrumb)
        assert.is_same({
            flags = {
                unimplemented = false,
                failed = false,
            },
            names = {
                suite_1 = {
                    unimplemented = false,
                    failed = false,
                    names = {},
                },
            },
        }, context.suites)
    end)
    it("should add story", function()
        local context = ContextClass()

        local breadcrumb = {
            suite = "suite_1",
            story = "story_1",
        }
        context:add_suite(breadcrumb)
        context:add_story(breadcrumb)
        assert.is_same({
            flags = {
                unimplemented = false,
                failed = false,
            },
            names = {
                suite_1 = {
                    unimplemented = false,
                    failed = false,
                    names = {
                        story_1 = {
                            unimplemented = false,
                            failed = false,
                            names = {},
                        },
                    },
                },
            },
        }, context.suites)
    end)
    it("should add scenario", function()
        local context = ContextClass()

        local breadcrumb = {
            suite = "suite_1",
            story = "story_1",
            scenario = "scenario_1",
        }
        context:add_suite(breadcrumb)
        context:add_story(breadcrumb)
        context:add_scenario(breadcrumb)
        assert.is_same({
            flags = {
                unimplemented = false,
                failed = false,
            },
            names = {
                suite_1 = {
                    unimplemented = false,
                    failed = false,
                    names = {
                        story_1 = {
                            unimplemented = false,
                            failed = false,
                            names = {
                                scenario_1 = {
                                    unimplemented = false,
                                    failed = false,
                                },
                            },
                        },
                    },
                },
            },
        }, context.suites)
    end)
    it("should add step with a func", function()
        ContextClass.make_breadcrumb = function() return { suite = "suite 1", story = "story 1", scenario = 2, is_step = true } end

        local context = ContextClass()
        local step_context = {
            step = {
                func = function() end,
                args = {},
            },
            context_snapshot = {
                current_environment = {},
            },
            success = true,
        }


        context:add(step_context)
        assert.is_same({
            flags = {
                unimplemented = false,
                failed = false,
            },
            names = {
                ["suite 1"] = {
                    unimplemented = false,
                    failed = false,
                    names = {
                        ["story 1"] = {
                            unimplemented = false,
                            failed = false,
                            names = {
                                [2] = {
                                    unimplemented = false,
                                    failed = false,
                                },
                            },
                        },
                    },
                },
            },
        }, context.suites)
    end)
    it("should add step without a func", function()
        ContextClass.make_breadcrumb = function() return { suite = "suite 1", story = "story 1", scenario = 2, is_step = true } end
        local context = ContextClass()
        local step_context = {
            step = {
                func = nil,
            },
            success = true,
        }
        context:add(step_context)
        assert.is_same({
            flags = {
                unimplemented = true,
                failed = false,
            },
            names = {
                ["suite 1"] = {
                    unimplemented = true,
                    failed = false,
                    names = {
                        ["story 1"] = {
                            unimplemented = true,
                            failed = false,
                            names = {
                                [2] = {
                                    unimplemented = true,
                                    failed = false,
                                },
                            },
                        },
                    },
                },
            },
        }, context.suites)

    end)
    it("should add step with a failed func", function()
        ContextClass.make_breadcrumb = function() return { suite = "suite 1", story = "story 1", scenario = 2, is_step = true } end
        local context = ContextClass()
        local step_context = {
            step = {
                func = function() error("error") end,
            },
            success = false,
        }
        context:add(step_context)
        assert.is_same({
            flags = {
                unimplemented = false,
                failed = true,
            },
            names = {
                ["suite 1"] = {
                    unimplemented = false,
                    failed = true,
                    names = {
                        ["story 1"] = {
                            unimplemented = false,
                            failed = true,
                            names = {
                                [2] = {
                                    unimplemented = false,
                                    failed = true,
                                },
                            },
                        },
                    },
                },
            },
        }, context.suites)
    end)
end)
