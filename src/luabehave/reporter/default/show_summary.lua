local function gather_statistic(reporter_context)
    local statistic = {
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
        statistic.suites.total = statistic.suites.total + 1
        if suite.failed then
            statistic.suites.failed = statistic.suites.failed + 1
        else
            statistic.suites.passed = statistic.suites.passed + 1
        end
        for _, story in pairs(suite.names) do
            statistic.stories.total = statistic.stories.total + 1
            if story.failed then
                statistic.stories.failed = statistic.stories.failed + 1
            elseif story.unimplemented then
                statistic.stories.unimplemented = statistic.stories.unimplemented + 1
            else
                statistic.stories.passed = statistic.stories.passed + 1
            end
            for _, scenario in pairs(story.names) do
                statistic.scenarios.total = statistic.scenarios.total + 1
                if scenario.failed then
                    statistic.scenarios.failed = statistic.scenarios.failed + 1
                elseif scenario.unimplemented then
                    statistic.scenarios.unimplemented = statistic.scenarios.unimplemented + 1
                else
                    statistic.scenarios.passed = statistic.scenarios.passed + 1
                end
            end
        end
    end
    return statistic
end

return function(acxt)
    local statictic = gather_statistic(acxt.reporter_context)
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
