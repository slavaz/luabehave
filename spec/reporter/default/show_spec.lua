describe("Testing show function", function()
    local show = require("luabehave.reporter.default.show")

    it("should print all breadcrumbs and error description if step_result is not successful", function()
        local acxt = {
            output = {
                print = function() end
            },
            reporter = {
                context = {
                    steps_results = {
                        {
                            output_level = 1,
                            breadcrumbs = { "breadcrumb1", "breadcrumb2" },
                            success = false,
                            error_description = "error"
                        }
                    }
                }
            }
        }

        spy.on(acxt.output, "print")

        show(acxt)

        assert.spy(acxt.output.print).was.called(3)
        assert.spy(acxt.output.print).was.called_with(1, "breadcrumb1")
        assert.spy(acxt.output.print).was.called_with(1, "breadcrumb2")
        assert.spy(acxt.output.print).was.called_with(1, "Failure: error")
    end)

    it("should print all breadcrumbs if step_result is successful", function()
        local acxt = {
            output = {
                print = function() end
            },
            reporter = {
                context = {
                    steps_results = {
                        {
                            output_level = 1,
                            breadcrumbs = { "breadcrumb1", "breadcrumb2" },
                            success = true
                        }
                    }
                }
            }
        }

        spy.on(acxt.output, "print")

        show(acxt)

        assert.spy(acxt.output.print).was.called(2)
        assert.spy(acxt.output.print).was.called_with(1, "breadcrumb1")
        assert.spy(acxt.output.print).was.called_with(1, "breadcrumb2")
    end)
end)
