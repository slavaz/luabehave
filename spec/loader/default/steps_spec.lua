local path_to_examples = "spec/examples/loader/default"

describe('loader.default.stories', function()
    setup(function() end)
    teardown(function() end)

    it('happy path', function()
        local steps = require 'luabehave.loader.default.steps'
        local application_context = {}
        local file_list = {
            'spec/examples/loader/default/good_001.lua',
        }
        local ret_value, result = steps(application_context, file_list)
        assert.is_true(ret_value, "Error: " .. tostring(result))

        assert.not_nil(result["given"]['a given step'])
        assert.not_nil(result["given"]['a given step2'])
        assert.not_nil(result["when"]['a when step'])
        assert.not_nil(result["then"]['a then step'])
        assert.not_nil(result["before_scenario"])
        assert.not_nil(result["after_scenario"])
        assert.not_nil(result["before_suite"])
        assert.not_nil(result["after_suite"])
        assert.not_nil(result["before_story"])
        assert.not_nil(result["after_story"])
    end)
    it("Unhappy paths", function()
        local steps = require 'luabehave.loader.default.steps'
        local test_amount = 11

        for i = 1, test_amount do
            local file_name = ("bad_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local application_context = {}
            local ret_value, result = steps(application_context, { file_path .. ".lua" })
            assert.is_false(ret_value, "Error in: " .. file_path)

            local expected_result = 'An error occured in the file'
            assert.is_truthy(string.find(result, expected_result, 1, true),
                ("Unexpected error message in : %s"):format(file_path))
        end
    end)
end)
