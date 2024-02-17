local ContextClass = require('luabehave.planner.default.context')

describe("Tests for #planner.default.context", function()
    local context

    before_each(function ()
        context = ContextClass({},{},{})
    end)

    it("should initialize a default suite", function ()
        context:init_suite("My Suite")
        assert.is_equal(context.suite.name, "My Suite")
        assert.is_not_nil(context.current_environment)
        assert.is_not_nil(context.suite.environment)
        assert.is_not_nil(context.suite.story)
        assert.is_not_nil(context.suite.story.scenario)
        assert.is_not_nil(context.suite.story.scenario.environment)
    end)

    it("should initialize a default story", function ()
        context:init_story({ name = "My Story" })
        assert.is_equal(context.suite.story.name, "My Story")
        assert.is_not_nil(context.current_environment)
        assert.is_not_nil(context.suite.environment)
        assert.is_not_nil(context.suite.story.scenario)
        assert.is_not_nil(context.suite.story.scenario.environment)
    end)

    it("should initialize a default scenario", function ()
        context:init_scenario("My Scenario", "My Scenario Name")
        assert.is_equal(context.suite.story.scenario.name, "My Scenario Name")
        assert.is_not_nil(context.current_environment)
        assert.is_not_nil(context.suite.environment)
        assert.is_not_nil(context.suite.story.scenario.environment)
    end)

    it("should take a snapshot of the context", function ()
        context:init_suite("My Suite")
        context:init_story({ name = "My Story" })
        context:init_scenario("My Scenario", "My Scenario Name")
        context.suite.story.scenario.unimplemented = true
        context.suite.story.scenario.examples.present = true
        context.suite.story.scenario.examples.args = { "arg1", "arg2" }
        context.suite.story.scenario.examples.row_number = 1

        local snapshot = context:snapshot()
        assert.is_equal(snapshot.current_environment, context.current_environment)
        assert.is_equal(snapshot.suite.name, context.suite.name)
        assert.is_equal(snapshot.suite.story.name, context.suite.story.name)
        assert.is_equal(snapshot.suite.story.scenario.name, context.suite.story.scenario.name)
        assert.is_equal(snapshot.suite.story.scenario.unimplemented, context.suite.story.scenario.unimplemented)
        assert.is_equal(snapshot.suite.story.scenario.examples.present, context.suite.story.scenario.examples.present)
        assert.is_equal(snapshot.suite.story.scenario.examples.args, context.suite.story.scenario.examples.args)
        assert.is_equal(snapshot.suite.story.scenario.examples.row_number,
            context.suite.story.scenario.examples.row_number)
    end)
    
    

end)