describe("Testing args function", function()
    local args = require("luabehave.planner.default.args")

    it("should return default values when no args are provided", function()
        local result = args()

        assert.equal("", result["planner.default.suites"])
        assert.equal("default", result["planner.default.suite.name"])
    end)

    it("should return provided values when args are provided", function()
        local input = {
            ["planner.default.suites"] = "test_suites",
            ["planner.default.suite.name"] = "test_name",
        }
        local result = args(input)

        assert.equal("test_suites", result["planner.default.suites"])
        assert.equal("test_name", result["planner.default.suite.name"])
    end)

    it("should return a mix of default and provided values when some args are provided", function()
        local input = {
            ["planner.default.suites"] = "test_suites",
        }
        local result = args(input)

        assert.equal("test_suites", result["planner.default.suites"])
        assert.equal("default", result["planner.default.suite.name"])
    end)
end)
