Story: It's a story for the engine

Some decription here

    Background:
        Given some step
        And second step

Scenario: Some Scenario
    Given a step with {param=some value}
    When I'm run the bdd-engine
    Then I want to catch a param from 'given' section via environment

Scenario: Yet another scenario. 
#   Environment should be cleaned up. And yes, it's a comment
    When I'm run the bdd-engine
    Then Should not any globals defined from previous scenario

Scenario: Some Scenario with examples
    Given a step with {param}
    When I'm run the bdd-engine
    Then I want to catch a param from 'given' section via environment

Examples:
!|param| param2|
|value 1|value2|
|value 3|value4|
|and value \| 3 with escaped symbol|
