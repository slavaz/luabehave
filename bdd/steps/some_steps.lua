Given("a step with {param}", function(args)
    print("a step with param=" .. args.param)
    _G.shared_param = args.param
end)

Then("I want to catch a param from 'given' section via environment", function()
    print("shared via environment param=" .. _G.shared_param)
end)

Then("Should not any globals defined from previous scenario", function ()
    print("shared via environment param should be nil")
    assert(_G.shared_param == nil, "shared_param should be nil")
end)
