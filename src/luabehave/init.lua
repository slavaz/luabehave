return function()
    local utils = require("luabehave.utils")
    local run = require("luabehave.run")
    local validate_args = require("luabehave.args.validate")
    local get_args_from_file = require("luabehave.args.file")
    local exit_handler_func = require("luabehave.exit_handler")
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

            if application_context[name].init and type(application_context[name].init) == "function" then
                application_context[name].init(application_context)
            end
        end
    end

    local function run_cmd_parser()
        local parser = argparse()
            :name "luabehave"
            :description
            [[LuaBehave is a BDD (Behavior-Driven Development) testing framework that parses
and runs BDD stories based on the Gherkin language.]]
            :epilog "For more info, see https://github.com/slavaz/luabehave"
        parser:option "-c" "--config"
            :description "Path to the configuration file"
            :argname "<file>"
            :default ".luabehave"
        parser:option "--suites"
            :description "Comma-separated list of suites to run"
            :argname "<suite1>,<suite2>,..."
        parser:flag "--ignore-unimplemented"
            :description "Assume that all steps are implemented (exit code will be 0)"
        parser:option "--log-level"
            :description "Set the log level. May be one of: trace, debug, info, warning, error"
            :choices { "trace", "debug", "info", "warning", "error" }
            :argname "<level>"
            :default "info"

        return parser:parse()
    end

    local cmd_args = run_cmd_parser()
    local file_args = get_args_from_file(cmd_args.config or ".luabehave")
    validate_args(file_args)

    local application_context = {
        args = utils.merge(file_args, cmd_args),
    }

    init_application_context(application_context)

    run(application_context)

    exit_handler_func(application_context)
end
