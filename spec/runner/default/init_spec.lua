describe("Testing default_runner", function()
    local default_runner = require("luabehave.runner.default.init")

    it("should have a name function that returns 'default'", function()
        assert.equal('default', default_runner.name())
    end)

    it("should have a run function", function()
        assert.is_function(default_runner.run)
    end)
end)
