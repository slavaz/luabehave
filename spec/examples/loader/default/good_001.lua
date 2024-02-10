BeforeSuite(function()
    print("BeforeSuite")
end)

AfterSuite(function()
    print("AfterSuite")
end)

BeforeScenario(function()
    print("BeforeScenario")
end)

AfterScenario(function()
    print("AfterScenario")
end)

BeforeStory(function()
    print("BeforeStory")
end)

AfterStory(function()
    print("AfterStory")
end)

Given("a given step", function()
    print("Given a step")
end)

Given("a given step2", function()
    print("Given a step")
end)

When("a when step", function()
    print("When a step")
end)

Then("a then step", function()
    print("Then a step")
end)
