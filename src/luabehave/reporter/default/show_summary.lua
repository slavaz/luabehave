local private = {}
if _G["__tests"] then
    _G["__tests"]["reporter_show_summary"] = private
end

function private.gather_scenario_statistic(statistic_context, scenario)
    statistic_context.scenarios.total = statistic_context.scenarios.total + 1
    if scenario.failed then
        statistic_context.scenarios.failed = statistic_context.scenarios.failed + 1
    elseif scenario.unimplemented then
        statistic_context.scenarios.unimplemented = statistic_context.scenarios.unimplemented + 1
    else
        statistic_context.scenarios.passed = statistic_context.scenarios.passed + 1
    end
end

function private.gather_story_statistic(statistic_context, story)
    statistic_context.stories.total = statistic_context.stories.total + 1
    if story.failed then
        statistic_context.stories.failed = statistic_context.stories.failed + 1
    elseif story.unimplemented then
        statistic_context.stories.unimplemented = statistic_context.stories.unimplemented + 1
    else
        statistic_context.stories.passed = statistic_context.stories.passed + 1
    end
    for _, scenario in pairs(story.names) do
        private.gather_scenario_statistic(statistic_context, scenario)
    end
end

function private.gather_suite_statistic(statistic_context, suite)
    statistic_context.suites.total = statistic_context.suites.total + 1
    if suite.failed then
        statistic_context.suites.failed = statistic_context.suites.failed + 1
    else
        statistic_context.suites.passed = statistic_context.suites.passed + 1
    end
    for _, story in pairs(suite.names) do
        private.gather_story_statistic(statistic_context, story)
    end
end

function private.gather_statistic(reporter_context)
    local statistic_context = {
        suites = {
            total = 0,
            passed = 0,
            failed = 0,
        },
        stories = {
            total = 0,
            passed = 0,
            failed = 0,
            unimplemented = 0,
        },
        scenarios = {
            total = 0,
            passed = 0,
            failed = 0,
            unimplemented = 0,
        },
    }
    for _, suite in pairs(reporter_context.suites.names) do
        private.gather_suite_statistic(statistic_context, suite)
    end
    return statistic_context
end

return function(acxt)
    local statictic = private.gather_statistic(acxt.reporter_context)
    acxt.output.raw_print("-------------------------------------------------------------")
    acxt.output.raw_print("Summary:")
    acxt.output.raw_print("Suites: " ..
        statictic.suites.passed ..
        " passed, " .. statictic.suites.failed .. " failed, " .. statictic.suites.total .. " total")
    acxt.output.raw_print("Stories: " ..
        statictic.stories.passed ..
        " passed, " ..
        statictic.stories.failed ..
        " failed, " .. statictic.stories.unimplemented .. " unimplemented, " .. statictic.stories.total .. " total")
    acxt.output.raw_print("Scenarios: " ..
        statictic.scenarios.passed ..
        " passed, " ..
        statictic.scenarios.failed ..
        " failed, " .. statictic.scenarios.unimplemented .. " unimplemented, " .. statictic.scenarios.total .. " total")
end
