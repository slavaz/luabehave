local keywords = require("luabehave.parser.keywords")

describe("Keywords validation", function()
    it("should return true and default keywords when no keywords are provided", function()
        local result, validated_keywords = keywords.validate(nil)
        assert.is_true(result)
        assert.are.same(keywords.get_default(), validated_keywords)
    end)

    it("should return true and provided keywords when valid keywords are provided", function()
        local provided_keywords = {
            story                 = "Story: ",
            story_background      = "Background:",
            scenario              = "Scenario: ",
            before_step           = "Given ",
            action_step           = "When ",
            after_step            = "Then ",
            and_step              = "And ",
            scenario_parametrized = "Examples:",

            table_name            = "~|",
            table_header          = "!|",
            table_row             = "| ",

            comments              = { "#", "--" },
            escape                = "\\",
            spaces                = { " ", "\t" },
            open_bracket          = "{",
            close_bracket         = "}",
            equal                 = "=",
        }
        local result, validated_keywords = keywords.validate(provided_keywords)
        assert.is_true(result)
        assert.are.same(provided_keywords, validated_keywords)
    end)

    it("should return false and default keywords when invalid keywords are provided", function()
        local invalid_keywords = {
            story = "Story: ",
            feature = "Scenario: ",
            before_step = "Given ",
            action_step = "When ",
            after_step = "Then ",
            and_step = "And ",
            -- Missing comments
            spaces = { " ", "\t" },
        }
        local result, validated_keywords = keywords.validate(invalid_keywords)
        assert.is_false(result)
    end)

    it("should return false and error message when keywords is not a table", function()
        local invalid_keywords = "Invalid keywords"
        local result, error_message = keywords.validate(invalid_keywords)
        assert.is_false(result)
        assert.is_string(error_message)
    end)

    it("should return false and error message when a required keyword is missing", function()
        local invalid_keywords = {
            story = "Story: ",
            feature = "Scenario: ",
            before_step = "Given ",
            action_step = "When ",
            after_step = "Then ",
            and_step = "And ",
            comments = { "#", "--" },
            -- Missing spaces
        }
        local result, error_message = keywords.validate(invalid_keywords)
        assert.is_false(result)
        assert.is_string(error_message)
    end)

    it("should return false and error message when comments is not a table", function()
        local invalid_keywords = {
            story = "Story: ",
            feature = "Scenario: ",
            before_step = "Given ",
            action_step = "When ",
            after_step = "Then ",
            and_step = "And ",
            comments = "Invalid comments",
            spaces = { " ", "\t" },
        }
        local result, error_message = keywords.validate(invalid_keywords)
        assert.is_false(result)
        assert.is_string(error_message)
    end)

    it("should return false and error message when comments is empty", function()
        local invalid_keywords = {
            story = "Story: ",
            feature = "Scenario: ",
            before_step = "Given ",
            action_step = "When ",
            after_step = "Then ",
            and_step = "And ",
            comments = {},
            spaces = { " ", "\t" },
        }
        local result, error_message = keywords.validate(invalid_keywords)
        assert.is_false(result)
        assert.is_string(error_message)
    end)

    it("should return false and error message when spaces is not a table", function()
        local invalid_keywords = {
            story = "Story: ",
            feature = "Scenario: ",
            before_step = "Given ",
            action_step = "When ",
            after_step = "Then ",
            and_step = "And ",
            comments = { "#", "--" },
            spaces = "Invalid spaces",
        }
        local result, error_message = keywords.validate(invalid_keywords)
        assert.is_false(result)
        assert.is_string(error_message)
    end)

    it("should return false and error message when spaces is empty", function()
        local invalid_keywords = {
            story = "Story: ",
            feature = "Scenario: ",
            before_step = "Given ",
            action_step = "When ",
            after_step = "Then ",
            and_step = "And ",
            comments = { "#", "--" },
            spaces = {},
        }
        local result, error_message = keywords.validate(invalid_keywords)
        assert.is_false(result)
        assert.is_string(error_message)
    end)
end)
