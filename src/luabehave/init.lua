local utils = require("luabehave.utils")
local run = require("luabehave.run")
local validate_args = require("luabehave.args.validate")
local get_args_from_file = require("luabehave.args.file")
local argparse = require("argparse")

local factories = {
    finder = require("luabehave.finder"),
    planner = require("luabehave.planner"),
    output = require("luabehave.output"),
    runner = require("luabehave.runner"),
    loader = require("luabehave.loader"),
    parser = require("luabehave.parser"),
    keywords = require("luabehave.keywords"),
    reporter = require("luabehave.reporter"),
}

local function init_application_context(application_context)
    for name, factory in pairs(factories) do
        application_context[name] = factory.get(application_context.args)
    end
    application_context.exit_code = 0
end

local function run_cmd_parser()
    local parser = argparse()
        :name "luabehave"
        :description
        [[LuaBehave is a BDD (Behavior-Driven Development) testing framework that parses and runs BDD stories based on the Gherkin language. ]]
        :epilog "For more info, see https://github.com/slavaz/luabehave"
    parser:option "-c" "--config"
        :description "Path to the configuration file"
        :argname "<file>"
        :default ".luabehave"
    parser:option "--suites"
        :description "Comma-separated list of suites to run"
        :argname "<suite1>,<suite2>,..."
    return parser:parse()
end
return function()
    local cmd_args = run_cmd_parser()
    local file_args = get_args_from_file(cmd_args.config or ".luabehave")
    validate_args(file_args)

    local application_context = {
        args = utils.merge(file_args, cmd_args),
    }
    init_application_context(application_context)

    local ret_val, result = run(application_context)
    if not ret_val then
        application_context.output.error(result)
        os.exit(1)
    end
    os.exit(application_context.exit_code)
end
