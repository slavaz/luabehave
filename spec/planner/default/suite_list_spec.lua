describe("tests for #planner.default.suite_list", function()
    local validate_args = spy(function(args)
        return args
    end)

    setup(function()
        package.loaded["luabehave.finder.default.args"] = validate_args
    end)

    teardown(function()
        package.loaded["luabehave.finder.default.args"] = nil
    end)

    it("should return suites from args", function()
        local get_suites = require("luabehave.planner.default.suite_list")

        local acxt = {
            args = { ["planner.default.suites"] = "suite4, suite5, suite6" },
        }

        local context = {
            stories = {
                {
                    suites = { "suite1", "suite2", "suite3", "suite4" },
                },
                {
                    suites = { "suite6", "suite7" },
                },
            },
        }
        local suites = get_suites(acxt, context)
        assert.are.equal(2, #suites)
        assert.has_value("suite4", suites)
        assert.has_value("suite6", suites)
    end)
    it("should return list with all suites if no suites are specified", function()
        local get_suites = require("luabehave.planner.default.suite_list")

        local acxt = {
            args = {
                ["planner.default.suites"] = "",
                ["planner.default.suite.name"] = "blabla"
            },
        }

        local context = {
            stories = {
                {
                    suites = { "suite1", "suite2", "suite3", "suite4" },
                },
                {
                    suites = { "suite3", "suite4", "suite6", "suite7", "suite8" },
                },
            },
        }
        local suites = get_suites(acxt, context)
        assert.are.equal(1, #suites)
        assert.has_value("blabla", suites)
    end)
end)
