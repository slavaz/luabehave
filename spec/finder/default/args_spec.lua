describe("Tests for #finder.default.args", function ()
    it("should return default values if no args were passed", function ()
        local args = require("luabehave.finder.default.args")()
        assert.is_equal("_steps.lua", args["finder.default.step.extention"])
        assert.is_equal("bdd/steps", args["finder.default.step.path"])
        assert.is_equal(".story", args["finder.default.story.extention"])
        assert.is_equal("bdd/stories", args["finder.default.story.path"])
    end)
    it("should return default values if empty args were passed", function ()
        local args = require("luabehave.finder.default.args")({})
        assert.is_equal("_steps.lua", args["finder.default.step.extention"])
        assert.is_equal("bdd/steps", args["finder.default.step.path"])
        assert.is_equal(".story", args["finder.default.story.extention"])
        assert.is_equal("bdd/stories", args["finder.default.story.path"])
    end)
    it("should return default values if some args were passed", function ()
        local args = require("luabehave.finder.default.args")({
            ["finder.default.step.extention"] = "steps.lua",
            ["finder.default.step.path"] = "steps",
            ["finder.default.story.extention"] = "story",
            ["finder.default.story.path"] = "stories",
        })
        assert.is_equal("steps.lua", args["finder.default.step.extention"])
        assert.is_equal("steps", args["finder.default.step.path"])
        assert.is_equal("story", args["finder.default.story.extention"])
        assert.is_equal("stories", args["finder.default.story.path"])
    end)
end)