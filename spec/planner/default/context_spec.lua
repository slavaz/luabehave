local ContextClass = require('luabehave.planner.default.context')

describe("Context", function ()
    local context

    before_each(function ()
        context = ContextClass()
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

        local snapshot = context:snapshot()

        assert.is_equal(snapshot.current_environment, context.current_environment)
        assert.is_equal(snapshot.suite_name, context.suite.name)
        assert.is_equal(snapshot.story_name, context.suite.story.name)
        assert.is_equal(snapshot.scenario_name, context.suite.story.scenario.name)
    end)
    
    

end)