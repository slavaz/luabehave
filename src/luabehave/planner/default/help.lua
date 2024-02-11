return function(_)
    return [[
The default planner submodule is used to make executive plan of stories based on step definitions.
The default planner submodule uses the following arguments:
    [--planner.default.suites=<suite1,suite2,..>]
      comma separated list of suites to run (default: all)
      Suites should be defined in story files using the <keywords.suite> keyword (default: 'Suite: ')
    [--planner.default.suite.name=<suite_name>]
      A name for the default suite (default name: 'default')
    ]]
end
