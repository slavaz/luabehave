_G["__tests"] = {}

local function get_private()
    return _G["__tests"]["reporter_show_story_private"]
end
local package_name = "luabehave.reporter.default.show_story"

describe("Tests for #reporter.default.show_story", function()
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
        assert_snapshot = assert:snapshot()
    end)

    after_each(function()
        assert_snapshot:revert()
        for k, v in pairs(spy_funcs) do v:clear() end
        package.loaded[package_name] = nil
    end)
    it("should return a keyword", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Story",
        }
        local result = private.get_keyword(step_context)
        assert.is_equal("Story", result)
    end)
    it("should return a message", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            context_snapshot = {
                suite = {
                    story = {
                        name = "A Story",
                    },
                },
            },
        }
        local result = private.get_msg(step_context)
        assert.is_equal("A Story", result)
    end)
    it("should return a format", function()
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
    it("should return a format for unimplemented story", function()
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
        }
        local result = private.get_format(step_context)
        assert.is_equal("Skipping [unimplemented] %s %s", result)
    end)
    it("should show before story handler", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Story",
            step = {
                name = "__before_story",
            },
            context_snapshot = {
                suite = {
                    story = {
                        name = "A Story",
                        unimplemented = false,
                    },
                },
            },
        }
        local keywords = {
            story = "Story",
        }
        local output = mock_tables.output
        spy.on(output, "info")
        private.show_before({ output = output }, step_context, keywords)
        assert.spy(output.info).was_called_with("Running Story A Story")
    end)
    it("should show after story handler", function()
        require(package_name)
        local private = get_private()
        local step_context = {
            keyword = "Story",
            step = {
                name = "__after_story",
            },
            context_snapshot = {
                suite = {
                    story = {
                        name = "A Story",
                        unimplemented = false,
                    },
                },
            },
        }
        local keywords = {
            story = "Story",
        }
        local output = mock_tables.output
        spy.on(output, "debug")
        private.show_after({ output = output }, step_context, keywords)
        assert.spy(output.debug).was_called_with("Finishing Story A Story")
    end)
    it("should run show_before function", function()
        local show_story = require(package_name)
        local private = get_private()
        private.show_before = spy.new(function() return true end)
        private.show_after = spy.new(function() return false end)
        local result = show_story({}, {}, {})
        assert.is_true(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_not_called()
    end)
    it("should run show_after function", function()
        local show_story = require(package_name)
        local private = get_private()
        private.show_before = spy.new(function() return false end)
        private.show_after = spy.new(function() return true end)
        local result = show_story({}, {}, {})
        assert.is_true(result)
        assert.spy(private.show_before).was_called()
        assert.spy(private.show_after).was_called()
    end)
end)
