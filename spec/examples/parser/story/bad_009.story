# Wrong place for a table.

Background:
    Given a step
    And step2
    And Step3

Scenario: scenario
~!table1|
!|header1|
|val1|
    Given bla1
    When bla2
    Then bla3

Examples:
!|row1row2|
|val1|val2|
