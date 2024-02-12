local parser = require("luabehave.parser.default")
local keywords_factory = require("luabehave.keywords")

local path_to_examples = "spec/examples/parser/story"

local application_contaxt = {
    args = {},
    keywords = keywords_factory.get({}),
}
describe("Parse stories from examples", function()
    it("Should parse a story from example file", function()
        local test_amount = 3

        for i = 1, test_amount do
            local file_name = ("good_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local file = io.open(file_path .. ".story", "r")
            assert.is_not_nil(file, ("Failed to open file %s.story"):format(file_path))
            local ret_value, result = parser.parse(application_contaxt, file)
            file:close()
            assert.is_true(ret_value, ("Failed to parse file %s.story: %s"):format(file_path, result))
            local expected_result = dofile(file_path .. ".lua")
            assert.are.same(expected_result, result, ("Failed to parse file %s.story"):format(file_path))
        end

    end)

    it("should fail to parse a story from example file", function()
        local test_amount = 13

        for i = 1, test_amount do
            local file_name = ("bad_%03d"):format(i)
            local file_path = ("%s/%s"):format(path_to_examples, file_name)
            local file = io.open(file_path .. ".story", "r")
            assert.is_not_nil(file, ("Failed to open file %s.story"):format(file_path))
            local ret_value, result = parser.parse(application_contaxt, file)
            file:close()
            local expected_result = dofile(file_path .. ".lua")

            assert.is_false(ret_value, ("Expected to fail parsing file %s.story"):format(file_path))
            assert.are.same(expected_result, result, ("File parsing should be failed %s.story"):format(file_path))
        end
    end)
    it("very important test", function()
        local file_path = ("%s/very_important_test.png"):format(path_to_examples)
        local file = io.open(file_path, "r")
        assert.is_not_nil(file, ("Failed to open file %s"):format(file_path))
        local ret_value, result = parser.parse(application_contaxt, file)
        file:close()
        assert.is_false(ret_value, ("Expected to fail parsing file %s"):format(file_path))
        assert.are.same("A Story has no scenarios", result, ("File parsing should be failed %s"):format(file_path))
    end)
end)
