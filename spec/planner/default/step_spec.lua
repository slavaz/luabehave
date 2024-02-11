local Context = require("luabehave.planner.default.context")
describe("Tests for planner step modeule", function()
    it("should add a step into steps implementation table", function()
        local make_step = require("luabehave.planner.default.step")
        local context = Context({}, {})
        local steps = {
            {
                name = "step1",
                args = {}
            }
        }
        make_step({}, context, {}, steps)
        assert.is.equal(1, #context.executable_steps)

    end)
end)
