return {
    description = {
        "",
        "Some decription here",
        ""
    },
    name = "It's a story for the engine",
    scenarios = {
        {
            examples = {
                {
                    param = "value 1",
                    param2 = "value2"
                },
                {
                    param = "value 3",
                    param2 = "value4"
                },
                {
                    param = "and value | 3 with escaped symbol"
                }
            },
            given_steps = {
                {
                    args = {
                        param = ""
                    },
                    name = "a step with {param}"
                }
            },
            name = "Some Scenario with examples",
            then_steps = {
                {
                    args = {
                    },
                    name = "I want to catch a param from 'given' section via environment"
                }
            },
            when_steps = {
                {
                    args = {
                    },
                    name = "I'm run the bdd-engine"
                }
            }
        }
    },
    suites = {
    }
}
