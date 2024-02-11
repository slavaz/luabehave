local utils = require('luabehave.utils')

return function(acxt, OUTPUT_LEVEL, step_execution_result)
    step_execution_result.output_level = OUTPUT_LEVEL
    utils.add_to_table(acxt.reporter.context.steps_results, step_execution_result)
end
