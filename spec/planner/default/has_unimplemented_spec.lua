describe("tests for #planner.default.has_unimplemented", function()
    it("returns true if the parsed steps list has unimplemented steps", function()
        local has_unimplemented = require("luabehave.planner.default.has_unimplemented")
        local scenario_steps = { { name = "step1" }, { name = "step2" }, { name = "step3" } }
        local step_implementations = { step1 = true, step2 = true }

        assert.is_true(has_unimplemented(scenario_steps, step_implementations))
    end)

    it("returns false if the parsed steps list has no unimplemented steps", function()
        local has_unimplemented = require("luabehave.planner.default.has_unimplemented")
        local scenario_steps = { { name = "step1" }, { name = "step2" }, { name = "step3" } }
        local step_implementations = { step1 = true, step2 = true, step3 = true }

        assert.is_false(has_unimplemented(scenario_steps, step_implementations))
    end)
    it("returns true if the parsed steps list has nos teps at all", function()
        local has_unimplemented = require("luabehave.planner.default.has_unimplemented")
        local scenario_steps = nil
        local step_implementations = { step1 = true, step2 = true }

        assert.is_false(has_unimplemented(scenario_steps, step_implementations))
    end)
end)
