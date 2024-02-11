local environment = require('luabehave.planner.default.environment')

local ContextClass = {}
ContextClass.__index = ContextClass

setmetatable(ContextClass, {
    __call = function(cls, ...)
        return cls:_init(...)
    end,
})

local function get_default_scenario(self)
    return {
        parsed = nil,
        name = "",
        environment = environment.init(self.current_environment),
        unimplemented = false,
        examples = {
            present = false,
            args = {},
            row_number = 0,
        },
        step = {
            name = ""
        }
    }
end

local function get_default_story(self)
    return {
        parsed = {},
        name = "",
        environment = environment.init(self.current_environment),
        scenario = get_default_scenario(self),
    }
end

local function get_default_suite(self)
    return {
        name = "",
        environment = environment.init(),
        story = get_default_story(self),
    }
end

function ContextClass:snapshot()
    return {
        current_environment = self.current_environment,
        suite_name = self.suite.name,
        story_name = self.suite.story.name,
        story_path = self.suite.story.path,
        scenario_name = self.suite.story.scenario.name,
        scenario_unimplemented = self.suite.story.scenario.unimplemented,
        scenario_examples_present = self.suite.story.scenario.examples.present,
        scenario_examples_args = self.suite.story.scenario.examples.args,
        scenario_examples_row_number = self.suite.story.scenario.examples.row_number,
    }
end

function ContextClass:init_scenario(scenario, name)
    self.suite.story.scenario = get_default_scenario(self)
    self.suite.story.scenario.parsed = scenario
    self.suite.story.scenario.name = name
    self.current_environment = self.suite.story.scenario.environment
end

function ContextClass:init_story(story)
    self.suite.story = get_default_story(self)
    self.suite.story.parsed = story
    self.suite.story.name = story.name
    self.current_environment = self.suite.story.environment
end

function ContextClass:init_suite(suite_name)
    self.suite = get_default_suite(self)
    self.suite.name = suite_name
    self.current_environment = self.suite.environment
end

function ContextClass:_init(stories, step_implementations)
    local context_obj = {
        step_implementations = step_implementations,
        stories = stories,

        executable_steps = {},

        curent_environment = nil,
        suite = get_default_suite(self),
    }
    setmetatable(context_obj, self)
    return context_obj
end

return ContextClass
