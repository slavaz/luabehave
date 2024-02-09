Story: some story name
Here miltiline description.
Line2.
Line3

Background:
    Given a step 1 for running before all scenarios
    And some step with {param1=some value}
    And a step with a table named {table_1}
    ~|table_1|
    !|param1|param2|param3|
    |value1|value2|value3|
    |value5|value6|value7|

# a comment
    # a comment
-- a comment too
    -- a comment too

Scenario: some scenario name

    Given some given step with {param1=some value}
      And the step should be in 'Given' section
      ~|param2|
      !|header1|header2|
      |val1|val2|val3|
      |val1|val2|val3|val4|
      And the step with {param3}
      ~|param3|
      !|header13|header23|
      |val13|val23|val33|
      |val13|val23|val33|val43|
    When a 'when' step
      And the step should be in 'When' section
    Then a 'then' step
     And the step should be in 'Then' section

Examples:
# here an examples table
!|name1|param2|
|value1|value2|
|value3|value4|


Scenario: some scenario 2 name

    Given some given step with {param1=some value}
      And the step should be in 'Given' section {parammmmmm2}
      ~|parammmmmm2|
      !|header1|header2|
      |val1|val2|val3|
      |val1|val2|val3|val4|
      And the step with {param2}
      ~|param3|
      !|header13|header23|
      |val13|val23|val33|
      |val13|val23|val33|val43|
    When a 'when' step
      And the step should be in 'When' section
    Then a 'then' step
     And the step should be in 'Then' section
