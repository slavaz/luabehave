local parse_story = require("luabehave.parser.init")

local path_to_examples = "spec/examples/parser/story"

describe("Parse stories from examples", function()
    it("Should parse a story from example file", function()
        local test_amount = 2

        for i = 1, test_amount do
            local file_name = ("good_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local file = io.open(file_path .. ".story", "r")
            assert.is_not_nil(file, ("Failed to open file %s.story"):format(file_path))
            local ret_value, result = parse_story(file)
            file:close()
            assert.is_true(ret_value, ("Failed to parse file %s.story: %s"):format(file_path, result))
            local expected_result = dofile(file_path .. ".lua")
            assert.are.same(expected_result, result, ("Failed to parse file %s.story"):format(file_path))
        end

    end)

    it("should fail to parse a story from example file", function()
        local test_amount = 12

        for i = 1, test_amount do
            local file_name = ("bad_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local file = io.open(file_path .. ".story", "r")
            assert.is_not_nil(file, ("Failed to open file %s.story"):format(file_path))
            local ret_value, result = parse_story(file)
            file:close()
            local expected_result = dofile(file_path .. ".lua")

            assert.is_false(ret_value, ("Expected to fail parsing file %s.story"):format(file_path))
            assert.are.same(expected_result, result, ("File parsing should be failed %s.story"):format(file_path))
        end
    end)
end)
