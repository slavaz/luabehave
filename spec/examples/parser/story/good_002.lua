return {
    background = {
        { args = {},                        name = "a step 1 for running before all scenarios" },
        { args = { param1 = "some value" }, name = "some step with {param1}" },
        {
            args = {
                table_1 = {
                    { param1 = "value1", param2 = "value2", param3 = "value3" },
                    { param1 = "value5", param2 = "value6", param3 = "value7" }
                }
            },
            name = "a step with a table named {table_1}"
        }
    },
    description = {
        "Here miltiline description.",
        "Line2.",
        "Line3",
        "",
        "The table will not be parsed and will be placed in story description as is.",
        "    ~|table_1|",
        "    !|param1|param2|param3|",
        "    |value1|value2|value3|",
        "    |value5|value6|value7|",
        "  ",
        "    these steps also are not parsed, as there are in the story description.",
        "",
        "    Given a step 1 for running before all scenarios",
        "    And some step with {param1=some value}",
        "    And a step with a table named {table_1}",
        "",
        ""
    },
    name = "some story name",
    suites = { "suite1", "suite2", "suite3" },
    scenarios = {
        {
            examples = { { name1 = "value1", param2 = "value2" }, { name1 = "value3", param2 = "value4" } },
            given_steps = {
                { args = { param1 = "some value" }, name = "some given step with {param1}" },
                {
                    args = {
                        param2 = {
                            { "val3", header1 = "val1", header2 = "val2" },
                            { "val3", "val4",           header1 = "val1", header2 = "val2" }
                        }
                    },
                    name = "the step should be in 'Given' section"
                },
                {
                    args = {
                        param3 = {
                            { "val33", header13 = "val13", header23 = "val23" },
                            { "val33", "val43",            header13 = "val13", header23 = "val23" }
                        }
                    },
                    name = "the step with {param3}"
                }
            },
            name = "some scenario name",
            then_steps = {
                { args = {}, name = "a 'then' step" },
                { args = {}, name = "the step should be in 'Then' section" }
            },
            when_steps = {
                { args = {}, name = "a 'when' step" },
                { args = {}, name = "the step should be in 'When' section" }
            }
        },
        {
            given_steps = {
                { args = { param1 = "some value" }, name = "some given step with {param1}" },
                {
                    args = {
                        parammmmmm2 = {
                            { "val3", header1 = "val1", header2 = "val2" },
                            { "val3", "val4",           header1 = "val1", header2 = "val2" }
                        }
                    },
                    name = "the step should be in 'Given' section {parammmmmm2}"
                },
                {
                    args = {
                        param2 = "",
                        param3 = {
                            { "val33", header13 = "val13", header23 = "val23" },
                            { "val33", "val43",            header13 = "val13", header23 = "val23" }
                        }
                    },
                    name = "the step with {param2}"
                }
            },
            name = "some scenario 2 name",
            then_steps = {
                { args = {}, name = "a 'then' step" },
                { args = {}, name = "the step should be in 'Then' section" }
            },
            when_steps = {
                { args = {}, name = "a 'when' step" },
                { args = {}, name = "the step should be in 'When' section" }
            }
        }
    }
}
