local ContextClass = {}
ContextClass.__index = ContextClass

setmetatable(ContextClass, {
    __call = function(cls, ...)
        return cls:_init(...)
    end,
})

function ContextClass.is_step(_, step_context)
    local handler_names = {
        "__before_suite",
        "__after_suite",
        "__before_story",
        "__after_story",
        "__before_scenario",
        "__after_scenario",
    }
    for _, handler_name in ipairs(handler_names) do
        if step_context.step.name == handler_name then
            return false
        end
    end
    return true
end

function ContextClass:make_breadcrumb(step_context)
    local breadcrumb = {
        suite = step_context.context_snapshot.suite.name,
    }
    breadcrumb.story = step_context.context_snapshot.suite.story and
        step_context.context_snapshot.suite.story.path or ""
    breadcrumb.scenario = breadcrumb.story and step_context.context_snapshot.suite.story.scenario and
        step_context.context_snapshot.suite.story.scenario.number or 0
    breadcrumb.is_step = self:is_step(step_context)
    return breadcrumb
end

function ContextClass:add_suite(breadcrumb)
    if not self.suites.names[breadcrumb.suite] then
        self.suites.names[breadcrumb.suite] = {
            unimplemented = false,
            failed = false,
            names = {}
        }
    end
end

function ContextClass:add_story(breadcrumb)
    local suite_context = self.suites.names[breadcrumb.suite]

    if not suite_context.names[breadcrumb.story] then
        suite_context.names[breadcrumb.story] = {
            unimplemented = false,
            failed = false,
            names = {}
        }
    end
end

function ContextClass:add_scenario(breadcrumb)
    local suite_context = self.suites.names[breadcrumb.suite]
    local story_context = suite_context.names[breadcrumb.story]

    if not story_context.names[breadcrumb.scenario] then
        story_context.names[breadcrumb.scenario] = {
            unimplemented = false,
            failed = false,
        }
    end
end

function ContextClass:add(step_context)
    local breadcrumb = self:make_breadcrumb(step_context)
    self:add_suite(breadcrumb)
    self:add_story(breadcrumb)
    self:add_scenario(breadcrumb)

    if step_context.step.func == nil and breadcrumb.is_step then
        self.suites.names[breadcrumb.suite].unimplemented = true
        self.suites.names[breadcrumb.suite].names[breadcrumb.story].unimplemented = true
        self.suites.names[breadcrumb.suite].names[breadcrumb.story].names[breadcrumb.scenario].unimplemented = true
    end
    if not step_context.success then
        self.suites.names[breadcrumb.suite].failed = true
        self.suites.names[breadcrumb.suite].names[breadcrumb.story].failed = true
        self.suites.names[breadcrumb.suite].names[breadcrumb.story].names[breadcrumb.scenario].failed = true
    end
end

function ContextClass:_init()
    local context_obj = {
        suites = {
            flags = {
                unimplemented = false,
                failed = false,
            },
            names = {},
        }
    }
    setmetatable(context_obj, self)
    return context_obj
end

return ContextClass
