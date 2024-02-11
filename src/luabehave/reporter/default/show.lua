return function(acxt)
    local output = acxt.output
    for _, step_result in ipairs(acxt.reporter.context.steps_results) do
        for _, breadcrumb in ipairs(step_result.breadcrumbs) do
            output.print(step_result.output_level, breadcrumb)
        end
        if not step_result.success then
            output.print(step_result.output_level, "Failure: " .. step_result.error_description)
        end
    end
end
