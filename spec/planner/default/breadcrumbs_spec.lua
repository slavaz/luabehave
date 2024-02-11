describe("Breadcrumbs", function()
    local make_breadcrumbs = require("luabehave.planner.default.breadcrumbs")

    it("should initialize with an empty table", function()
        local acxt = {
            keywords = {
                get = function() return { suite = "Suite", story = "Story", scenario = "Scenario" } end
            }
        }
        local context_snapshot = {
            suite = { story = { scenario = {} } },
        }
        local breadcrumbs = make_breadcrumbs(acxt, context_snapshot, "Step Name")
        assert.are.same({}, breadcrumbs)
    end)

    it("should add suite name to breadcrumbs", function()
        local acxt = {
            keywords = {
                get = function() return { suite = "Suite", story = "Story", scenario = "Scenario" } end
            }
        }
        local context_snapshot = { suite_name = "SuiteName" }

        local breadcrumbs = make_breadcrumbs(acxt, context_snapshot, "Step Name")
        assert.are.same({ "Suite SuiteName" }, breadcrumbs)
    end)

    it("should add story name to breadcrumbs", function()
        local acxt = {
            keywords = {
                get = function() return { suite = "Suite", story = "Story", scenario = "Scenario" } end
            }
        }
        local context_snapshot = {
            suite_name = "SuiteName", story_name = "StoryName"
        }
        local breadcrumbs = make_breadcrumbs(acxt, context_snapshot, "Step Name")
        assert.are.same({ "Suite SuiteName", "Story StoryName (nil)" }, breadcrumbs)
    end)

    it("should add story path", function()
        local acxt = {
            keywords = {
                get = function() return { suite = "Suite", story = "Story", scenario = "Scenario" } end
            }
        }
        local context_snapshot = {
            suite_name = "SuiteName", story_name = "StoryName", story_path = "StoryPath"
        }
        local breadcrumbs = make_breadcrumbs(acxt, context_snapshot, "Step Name")
        assert.are.same({ "Suite SuiteName", "Story StoryName (StoryPath)" }, breadcrumbs)
        
    end)
    it("should add scenario name to breadcrumbs", function()
        local acxt = {
            keywords = {
                get = function() return { suite = "Suite", story = "Story", scenario = "Scenario" } end
            }
        }
        local context_snapshot = {
            suite_name = "SuiteName", story_name = "StoryName", scenario_name = "ScenarioName"
        }
        local breadcrumbs = make_breadcrumbs(acxt, context_snapshot, "Step Name")
        assert.are.same({ "Suite SuiteName", "Story StoryName (nil)", "Scenario ScenarioName" }, breadcrumbs)
    end)
end)
