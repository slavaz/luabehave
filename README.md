# luabehave
A Lua framework that allows to run BDD-style user stories.*

## Description

LuaBehave is a BDD (Behavior-Driven Development) testing framework that parses and runs BDD stories based on the Gherkin language. 

Gherkin is a plain-text language with a simple structure. It is designed to be easy to learn by non-programmers, yet structured enough to allow concise description of test scenarios and examples to illustrate business rules in most real-world domains.

Here is an example:

```
Story: Guess the word

  # The first example has two steps
  Scenario: Maker starts a game
    When the Maker starts a game
    Then the Maker waits for a Breaker to join

  # The second example has three steps
  Scenario: Breaker joins a game
    Given the Maker has started a game with the word "silky"
    When the Breaker joins the Maker's game
    Then the Breaker must guess a word with 5 characters
```


## Installation

```bash
git clone git@github.com:slavaz/luabehave.git
cd luabehave
luarocks make --local
or 
luarocks make
```

## Why it was written?

I was too lazy to search for a suitable BDD-framework on the Internet, so I wrote my own.
I know about the Cucumber project, but I don't like its Lua implementation...

## Usage

The BDD-framework is based (but not strictly followed) on Gherkin language: https://cucumber.io/docs/gherkin/reference/#keywords

For usage examples, see the [bdd/steps](https://github.com/slavaz/luabehave/tree/main/bdd/steps) and [bdd/stories](https://github.com/slavaz/luabehave/tree/main/bdd/stories) directories.

### Code

The following global functions are declared for registering functions that implement steps:

```lua
Given("step_name", function(args)
-- a step implementation
end)

When("step_name", function(args)
-- a step implementation
end)

Then("step_name",function(args)
-- a step implementation
end)

BeforeScenario(function(args)
-- is running before each scenario
end)

AfterScenario(function(args)
-- is running after each scenario
end)

BeforeStory(function(args)
-- is running before each sttory
end)

AfterStory(function(args)
-- is running after each story
end)

BeforeSuite(function(args)
-- is running before each suite
end)

AfterSuite(function(args)
-- is running after each suite
end)
```

### Scenarios

The main difference from classic Gherkin language is arguments definition. Steps are looks like:

```   
   Given a book written by {author=Name Surname} with {title=Very cool story}
     And a book written by {author=Name2 Surname2} with {title=Very very cool story, indeed}
```

both steps are handled by one step definition:

```lua
Given("a book written by {author} with {title}", function(args)
    print (args.author)
    print (args.title)
end
)
```

### Suites
Suite as fact it's a tag assigned to a scenario:

```
Suite: Some suite, Suite1, suiteN
Story: a story

Scenario: ....
```

By default, all test suites will be executed. The list of test suites can be specified using the command line parameter:

```
 --suites='comma separated list'
```

### Table definitions

Tables have 3 keywords: '|', '!|' and '~|'

keyword '~|' means table name
Keyword '!|' means 'header definitions' or keys in 'key-value' pairs
And keyword '|' means values separator. Below examples.

The table:

```
|val1|val2|
```
will be parsed to:
```lua
args = {
  {"val1", "val2"}
}
```

The table:
```
|val1|val2|
|val3|val4|
```
will be parsed to:
```lua
args = {
  {"val1", "val2"},
  {"val3", "val4"},
}
```

The table:
```
!|header1|header2|
|val1|val2|
```
will be parsed to:
```lua
args = {
  header1 = "val1",
  header2 = "val2",
}
```

The table:
```
!|header1|header2|
|val1|val2|val3|
```
will be parsed to:
```lua
args = {
  header1 = "val1",
  header2 = "val2",
  "val3"
}
```

The table:
```
!|header1|header2|
|val1|val2|
|val3|val4|
```
will be parsed to:
```lua
args = {
  {header1 = "val1", header2 = "val2"},
  {header1 = "val3", header2 = "val4"},
}
```

The table:
```
!|header1|header2|
|val1|val2|
|val3|val4|val5|
```
will be parsed to:
```lua
args = {
  {header1 = "val1", header2 = "val2"},
  {header1 = "val3", header2 = "val4", "val5"},
}
```

The table:
```
!|header1|header2|header3|
|val1|val2|
|val3|val4|val5|
```
will be parsed to:
```lua
args = {
  { header1 = "val1", header2 = "val2" },
  { header1 = "val3", header2 = "val4", header3 = "val5" },
}
```

and finally, the table:
```
~|table_name|
!|header1|header2|header3|
|val1|val2|
|val3|val4|val5|
```
will be parsed to:
```lua
args = {
  table_name = {
    { header1 = "val1", header2 = "val2" },
    { header1 = "val3", header2 = "val4", header3 = "val5" },
  }
}
```

### Notes
Some notes here:
 - each suite has own isolated execution environment for step definitions.
 - each story (feature) has own isolated execution environment based on suite env.
 - each scenario has own isolated execution environment based on story env.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

MIT (https://choosealicense.com/licenses/mit/)

## Contact

Slava Zanko - slavazanko@gmail.com

Project Link: https://github.com/slavaz/luabehave
