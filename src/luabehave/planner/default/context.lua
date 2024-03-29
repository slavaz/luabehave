local environment = require('luabehave.environment')

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
        number = 0,
        environment = environment.init(self.acxt, self.current_environment),
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
        unimplemented = false,
        name = "",
        environment = environment.init(self.acxt, self.current_environment),
        scenario = get_default_scenario(self),
    }
end

local function get_default_suite(self)
    return {
        name = "",
        environment = environment.init(self.acxt),
        story = get_default_story(self),
    }
end

function ContextClass:snapshot()
    return {
        current_environment = self.current_environment,
        suite = {
            name = self.suite.name,
            story = {
                environment = self.suite.story.environment,
                unimplemented = self.suite.story.unimplemented,
                name = self.suite.story.name,
                path = self.suite.story.path,
                scenario = {
                    environment = self.suite.story.scenario.environment,
                    number = self.suite.story.scenario.number,
                    name = self.suite.story.scenario.name,
                    unimplemented = self.suite.story.scenario.unimplemented,
                    examples = {
                        present = self.suite.story.scenario.examples.present,
                        args = self.suite.story.scenario.examples.args,
                        row_number = self.suite.story.scenario.examples.row_number,
                    }
                }
            }
        }
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

function ContextClass:_init(acxt, stories, step_implementations)
    local context_obj = {
        step_implementations = step_implementations,
        stories = stories,
        acxt = acxt,
        executable_steps = {},
        curent_environment = nil,
    }
    context_obj.suite = get_default_suite(context_obj)
    setmetatable(context_obj, self)
    return context_obj
end

return ContextClass
