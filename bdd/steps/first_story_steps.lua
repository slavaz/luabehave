Given("some step", function(args)
    print("Well, this is a FIRST executed step in a live of luabehave! Wooo-hooo!")
end)

Given("second step", function(args)
    print("Well, this yet is another step in a live of luabehave")
end)

When("I'm run the bdd-engine", function(args)
    print("Yeah, baby, go-go-go!")
end)

Then("I want to see everything works like a sharm, yeah", function(args)
    print("I'm seeing all the output... I'm happy!")
end)
