_G["__tests"] = {}

local Context = require("luabehave.planner.default.context")

local package_name = "luabehave.planner.default.story"
local function get_private()
    return _G["__tests"]["planner_story_private"]
end

describe("tests for  tests for #planner.default.story", function()
    local assert_snapshot

    local mock = {
        has_unimplemented_false = spy(function(_, _) return false end),
        has_unimplemented_true = spy(function(_, _) return true end),
        prepare_scenario = spy(),
        prepare_steps = spy(),
        validate_args = spy.new(function(args) return args end),
    }

    before_each(function()
        assert_snapshot = assert:snapshot()
        package.loaded["luabehave.planner.default.scenario"] = mock.prepare_scenario
        package.loaded["luabehave.planner.default.step"] = mock.prepare_steps
        package.loaded["luabehave.planner.default.args"] = mock.validate_args
        package.loaded["luabehave.planner.default.has_unimplemented"] = mock.has_unimplemented_false
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(mock) do v:clear() end
        package.loaded[package_name] = nil
    end)

    it("should prepare before story handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            keywords = {
                get = function(acxt) return { story = "story" } end
            }
        }
        local planner_context = {
            step_implementations = {
                before_story = {
                    func = function() end
                }
            },
            executable_steps = {},
            snapshot = function() return {} end
        }
        private.prepare_before_story_handler(acxt, planner_context)
        assert.are.same(1, #planner_context.executable_steps)
        assert.are.same({
            keyword = "story",
            context_snapshot = {},
            step = {
                name = "__before_story",
                func = planner_context.step_implementations.before_story.func,
                args = {}
            }
        }, planner_context.executable_steps[1])
    end)
    it("should prepare after story handler", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            keywords = {
                get = function(acxt) return { story = "story" } end
            }
        }
        local planner_context = {
            step_implementations = {
                after_story = {
                    func = function() end
                }
            },
            executable_steps = {},
            snapshot = function() return {} end
        }
        private.prepare_after_story_handler(acxt, planner_context)
        assert.are.same(1, #planner_context.executable_steps)
        assert.are.same({
            keyword = "story",
            context_snapshot = {},
            step = {
                name = "__after_story",
                func = planner_context.step_implementations.after_story.func,
                args = {}
            }
        }, planner_context.executable_steps[1])
    end)
    it("should not prepare background plan", function()
        require(package_name)
        local private = get_private()
        local planner_context = {
            suite = {
                story = {
                    parsed = {}
                }
            }
        }
        private.prepare_background_plan(acxt, planner_context)
        assert.spy(mock.prepare_steps).was_not.called()
    end)
    it("should prepare background plan", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            keywords = {
                get = function(acxt) return { story_background = "background" } end
            }
        }
        local planner_context = {
            suite = {
                story = {
                    parsed = {
                        background = {}
                    }
                }
            },
            step_implementations = {
                given = {
                    func = function() end
                }
            }
        }
        private.prepare_background_plan(acxt, planner_context)
        assert.spy(mock.prepare_steps).was.called_with(planner_context, planner_context.step_implementations["given"],
            planner_context.suite.story.parsed.background, "background")
    end)
    it("should return true if suite is in current suite", function()
        require(package_name)
        local private = get_private()
        local planner_context = {
            suite = {
                name = "default"
            }
        }
        local parsed_story = {
            suites = { "default" }
        }
        assert.is_true(private.in_current_suite(planner_context, parsed_story, "default"))
    end)
    it("should return true if suite is in current suite", function()
        require(package_name)
        local private = get_private()
        local planner_context = {
            suite = {
                name = "default"
            }
        }
        local parsed_story = {
            suites = { "default", "other" }
        }
        assert.is_true(private.in_current_suite(planner_context, parsed_story, "default"))
    end)
    it("should return true if suite is default", function()
        require(package_name)
        local private = get_private()
        local planner_context = {
            suite = {
                name = "default"
            }
        }
        local parsed_story = {
            suites = { "some", "other" }
        }
        assert.is_true(private.in_current_suite(planner_context, parsed_story, "default"))
    end)
    it("should return false if suite is not in current suite", function()
        require(package_name)
        local private = get_private()
        local planner_context = {
            suite = {
                name = "nondefault"
            }
        }
        local parsed_story = {
            suites = { "other" }
        }
        assert.is_false(private.in_current_suite(planner_context, parsed_story, "default"))
    end)
    it("should return false if suite is not in current suite", function()
        require(package_name)
        local private = get_private()
        local planner_context = {
            suite = {
                name = "nondefault"
            }
        }
        local parsed_story = {
            suites = { "other", "another" }
        }
        assert.is_false(private.in_current_suite(planner_context, parsed_story, "default"))
    end)

    it("should prepare stories from a list of stories", function()
        local prepare_stories = require(package_name)
        local private = get_private()
        private.prepare_story = spy.new(function(...) end)

        local planner_context = { stories = { {}, {} } }
        local acxt = { args = { arg1 = 'val' } }

        prepare_stories(acxt, planner_context)
        assert.spy(private.prepare_story).was.called(2)
        assert.spy(mock.validate_args).was.called_with({ arg1 = 'val' })
    end)

    it("should not prepare a plan for a story if private.in_current_suite returns false", function()
        require(package_name)
        local private = get_private()
        local planner_context = Context({ ["path1"] = {} }, {})
        local acxt = {
            keywords = { get = function(acxt) return { story = "story" } end },
        }
        local args = { ["planner.default.suite.name"] = "name" }

        local expected_planner_context = Context({ ["path1"] = {} }, {})
        private.in_current_suite = spy.new(function(...) return false end)
        private.prepare_before_story_handler = spy.new(function(...) end)
        private.prepare_after_story_handler = spy.new(function(...) end)
        private.prepare_background_plan = spy.new(function(...) end)

        private.prepare_story(acxt, planner_context, args, "path1", {})

        assert.spy(private.in_current_suite).was.called_with(expected_planner_context, {}, "name")
        assert.spy(private.prepare_before_story_handler).was_not.called()
        assert.spy(private.prepare_after_story_handler).was_not.called()
        assert.spy(private.prepare_background_plan).was_not.called()
        assert.spy(mock.prepare_scenario).was_not.called()
    end)
    it("should prepare a plan for a story if private.in_current_suite returns true", function()
        require(package_name)
        local private = get_private()
        local args = { ["planner.default.suite.name"] = "name" }
        local acxt = {
            keywords = { get = function(acxt) return { story = "story" } end },
        }
        local planner_context = Context(acxt, { ["path1"] = {} }, {})
        local expected_planner_context = Context(acxt, { ["path1"] = {} }, {})
        private.in_current_suite = spy(function(...) return true end)
        private.prepare_before_story_handler = spy()
        private.prepare_after_story_handler = spy()
        private.prepare_background_plan = spy()

        private.prepare_story(acxt, planner_context, args, "path1", {})

        assert.spy(private.in_current_suite).was.called_with(expected_planner_context, {}, "name")
        assert.spy(private.prepare_before_story_handler).was.called()
        assert.spy(private.prepare_after_story_handler).was.called()
        assert.spy(private.prepare_background_plan).was.called()
        assert.spy(mock.prepare_scenario).was.called()
    end)
    it("should mark a story as unimplemented if some of background steps are unimplemented", function()
        package.loaded["luabehave.planner.default.has_unimplemented"] = mock.has_unimplemented_true
        require(package_name)
        local private = get_private()
        local args = { ["planner.default.suite.name"] = "name" }
        local acxt = {
            keywords = { get = function(acxt) return { story = "story" } end },
        }
        local planner_context = Context(acxt, { ["path1"] = {} }, { given = {} })
        private.in_current_suite = spy(function(...) return true end)
        private.prepare_before_story_handler = spy()
        private.prepare_after_story_handler = spy()
        private.prepare_background_plan = spy()
        private.prepare_story(acxt, planner_context, args, "path1", { background = {} })
        assert.spy(mock.has_unimplemented_true).was.called_with(planner_context.suite.story.parsed.background, {})
        assert.is_true(planner_context.suite.story.unimplemented)
    end)
end)
