local a_factory = require("luabehave.runner.init")

describe("Finder factory tests", function()
    it("should return a list of submodules", function()
        assert.not_nil(a_factory.list)
        local submodules = a_factory.list()
        assert.not_nil(submodules[1])
    end)
    it("should return a default submodule", function()
        assert.not_nil(a_factory.get)
        local submodule = a_factory.get({})
        assert.not_nil(submodule)
    end)
    it("should return a default submodule with help", function()
        assert.not_nil(a_factory.get)
        local submodule = a_factory.get({})
        assert.not_nil(submodule.help)
        assert.is_string(submodule.help({}))
    end)
    it("should return a default submodule with name", function()
        assert.not_nil(a_factory.get)
        local submodule = a_factory.get({ parser = "default" })
        assert.not_nil(submodule.name)
    end)
end)
