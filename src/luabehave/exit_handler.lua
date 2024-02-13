return function(acxt)
    if acxt.runner_results.has_failed_steps then
        os.exit(1)
    end
    if acxt.runner_results.has_unimplemented_steps then
        os.exit(acxt.args["ignore-unimplemented"] and 0 or 2)
    end
    os.exit(0)
end
