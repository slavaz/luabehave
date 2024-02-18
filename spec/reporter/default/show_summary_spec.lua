_G["__tests"] = {}

local function get_private()
    return _G["__tests"]["reporter_show_summary"]
end
local package_name = "luabehave.reporter.default.show_summary"

describe("Tests for #reporter.default.show_summary", function()
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
            raw_print = function() end,
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
    it("should gather scatistic for a scenario with failed steps", function()
        require(package_name)
        local private = get_private()
        local statistic_context = {
            scenarios = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }
        local scenario_report = {
            failed = true,
        }
        private.gather_scenario_statistic(statistic_context, scenario_report)
        assert.is_equal(1, statistic_context.scenarios.total)
        assert.is_equal(1, statistic_context.scenarios.failed)
        assert.is_equal(0, statistic_context.scenarios.unimplemented)
        assert.is_equal(0, statistic_context.scenarios.passed)
    end)
    it("should gather scatistic for a scenario with unimplemented steps", function()
        require(package_name)
        local private = get_private()
        local statistic_context = {
            scenarios = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }
        local scenario_report = {
            unimplemented = true,
        }
        private.gather_scenario_statistic(statistic_context, scenario_report)
        assert.is_equal(1, statistic_context.scenarios.total)
        assert.is_equal(0, statistic_context.scenarios.failed)
        assert.is_equal(1, statistic_context.scenarios.unimplemented)
        assert.is_equal(0, statistic_context.scenarios.passed)
    end)
    it("should gather scatistic for a scenario with passed steps", function()
        require(package_name)
        local private = get_private()
        local acxt = {
            output = mock_tables.output,
        }
        local statistic_context = {
            scenarios = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }
        local scenario_report = {
            failed = false,
            unimplemented = false,
        }
        private.gather_scenario_statistic(statistic_context, scenario_report)
        assert.is_equal(1, statistic_context.scenarios.total)
        assert.is_equal(0, statistic_context.scenarios.failed)
        assert.is_equal(0, statistic_context.scenarios.unimplemented)
        assert.is_equal(1, statistic_context.scenarios.passed)
    end)
    it("should gather statistic for a story with failed scenarios", function()
        require(package_name)
        local private = get_private()
        private.gather_scenario_statistic = function() end
        local statistic_context = {
            stories = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }
        local story_report = {
            failed = true,
            names = { {} },
        }
        private.gather_story_statistic(statistic_context, story_report)
        assert.is_equal(1, statistic_context.stories.total)
        assert.is_equal(1, statistic_context.stories.failed)
        assert.is_equal(0, statistic_context.stories.unimplemented)
        assert.is_equal(0, statistic_context.stories.passed)
    end)
    it("should gather statistic for a story with unimplemented scenarios", function()
        require(package_name)
        local private = get_private()
        private.gather_scenario_statistic = function() end
        local statistic_context = {
            stories = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }
        local story_report = {
            failed = false,
            unimplemented = true,
            names = { {} },
        }
        private.gather_story_statistic(statistic_context, story_report)
        assert.is_equal(1, statistic_context.stories.total)
        assert.is_equal(0, statistic_context.stories.failed)
        assert.is_equal(1, statistic_context.stories.unimplemented)
        assert.is_equal(0, statistic_context.stories.passed)
    end)
    it("should gather statistic for a story with passed scenarios", function()
        require(package_name)
        local private = get_private()
        private.gather_scenario_statistic = function() end
        local statistic_context = {
            stories = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }
        local story_report = {
            failed = false,
            unimplemented = false,
            names = { {} },
        }
        private.gather_story_statistic(statistic_context, story_report)
        assert.is_equal(1, statistic_context.stories.total)
        assert.is_equal(0, statistic_context.stories.failed)
        assert.is_equal(0, statistic_context.stories.unimplemented)
        assert.is_equal(1, statistic_context.stories.passed)
    end)
    it("should gather statistic for a suite with failed storues", function()
        require(package_name)
        local private = get_private()
        private.gather_story_statistic = function() end
        local statistic_context = {
            suites = {
                total = 0,
                failed = 0,
                passed = 0,
            },
        }
        local suite_report = {
            failed = true,
            names = { {} },
        }
        private.gather_suite_statistic(statistic_context, suite_report)
        assert.is_equal(1, statistic_context.suites.total)
        assert.is_equal(1, statistic_context.suites.failed)
        assert.is_equal(0, statistic_context.suites.passed)
    end)
    it("should gather statistic for a suite with passed storues", function()
        require(package_name)
        local private = get_private()
        private.gather_story_statistic = function() end
        local statistic_context = {
            suites = {
                total = 0,
                failed = 0,
                passed = 0,
            },
        }
        local suite_report = {
            failed = false,
            names = { {} },
        }
        private.gather_suite_statistic(statistic_context, suite_report)
        assert.is_equal(1, statistic_context.suites.total)
        assert.is_equal(0, statistic_context.suites.failed)
        assert.is_equal(1, statistic_context.suites.passed)
    end)
    it("should gather overall statictic", function()
        require(package_name)
        local private = get_private()
        private.gather_suite_statistic = function() end
        local reporter_context = {
            suites = {
                names = { {} },
            },
        }
        local statistic_context = private.gather_statistic(reporter_context)
        assert.is_same({
            suites = {
                total = 0,
                failed = 0,
                passed = 0,
            },
            stories = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
            scenarios = {
                total = 0,
                failed = 0,
                unimplemented = 0,
                passed = 0,
            },
        }, statistic_context)
    end)
    it("should show summary", function()
        local show_summary_func = require(package_name)
        local private = get_private()
        private.gather_statistic = function()
            return {
                suites = {
                    total = 3,
                    failed = 2,
                    passed = 1,
                },
                stories = {
                    total = 4,
                    failed = 2,
                    unimplemented = 1,
                    passed = 1,
                },
                scenarios = {
                    total = 6,
                    failed = 3,
                    unimplemented = 2,
                    passed = 1,
                },
            }
        end
        local reporter_context = {
            suites = {
                names = { {} },
            },
        }
        mock_tables.output.raw_print = spy.new(function() end)
        show_summary_func({ output = mock_tables.output, reporter_context = reporter_context })
        assert.spy(mock_tables.output.raw_print).was_called_with(
            "-------------------------------------------------------------")
        assert.spy(mock_tables.output.raw_print).was_called_with("Summary:")
        assert.spy(mock_tables.output.raw_print).was_called_with("Suites: 1 passed, 2 failed, 3 total")
        assert.spy(mock_tables.output.raw_print).was_called_with("Stories: 1 passed, 2 failed, 1 unimplemented, 4 total")
        assert.spy(mock_tables.output.raw_print).was_called_with(
            "Scenarios: 1 passed, 3 failed, 2 unimplemented, 6 total")
    end)
end)
