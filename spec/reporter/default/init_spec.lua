describe("Testing default_reporter", function()
    local default_reporter = require("luabehave.reporter.default.init")

    it("should have a name function that returns 'default'", function()
        assert.equal('default', default_reporter.name())
    end)

    it("should have a context table", function()
        assert.is_table(default_reporter.context)
    end)

    it("should have a collect function", function()
        assert.is_function(default_reporter.collect)
    end)

    it("should have a show function", function()
        assert.is_function(default_reporter.show)
    end)

    it("should initialize a new context with steps_results table when init is called", function()
        local acxt = { reporter = {} }
        default_reporter.init(acxt)
        assert.is_table(acxt.reporter.context)
        assert.is_table(acxt.reporter.context.steps_results)
    end)
end)
