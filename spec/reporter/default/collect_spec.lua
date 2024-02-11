describe("Testing collect function", function()
    local collect = require("luabehave.reporter.default.collect")
    local utils = require('luabehave.utils')

    it("should add step_execution_result to steps_results with correct output_level", function()
        local acxt = { reporter = { context = { steps_results = {} } } }
        local step_execution_result = { result = true }

        collect(acxt, 1, step_execution_result)

        assert.equal(1, step_execution_result.output_level)
        assert.same({ step_execution_result }, acxt.reporter.context.steps_results)
    end)

    it("should call utils.add_to_table with correct arguments", function()
        local acxt = { reporter = { context = { steps_results = {} } } }
        local step_execution_result = { result = true }

        spy.on(utils, "add_to_table")

        collect(acxt, 1, step_execution_result)
    end)
end)
